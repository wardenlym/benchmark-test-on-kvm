# github.com/wardenlym
# mailto:wardenlym@gmail.com

# ensure put this scripts in perf-tests/clusterloader2
# because it depends on some stuffs in perf-tests/clusterloader2/pkg
CLUSTER_LOADER='./cmd/clusterloader'

# put cert files on *master-01* with correct user permission
# export this varibles because golang code use os.Getenv to get them
export ETCD_CERTIFICATE=/home/ubuntu/etcd/ca.crt
export ETCD_KEY=/home/ubuntu/etcd/ca.key
export KUBE_SSH_KEY_PATH=/home/ubuntu/.ssh/id_rsa

# master node info
MASTER_NAME=master-01
MASTER_IP=172.29.50.31
MASTER_INTERNAL_IP=172.29.50.31
KUBE_CONFIG=/home/ubuntu/.kube/config

# i run my test cluster on baremetal machines
PROVIDER='local'

# test suite config
NODE_NUM=3
B_NUM=50
C_NUM=150

TIME=`date +"%Y-%m-%d-%H%M"`
# directory to put test reports
REPORT_DIR="./reports-${TIME}"
mkdir $REPORT_DIR

# save logs output to help debugging
LOG_FILE="${REPORT_DIR}/stdout.log"

# i modify config to reduce test scale
TEST_CONFIG="${REPORT_DIR}/config.yaml"
TEST_DEPLOYMENT="${REPORT_DIR}/deployment.yaml"

cat > "${TEST_DEPLOYMENT}"<<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.Name}}
  labels:
    group: {{.Group}}
spec:
  replicas: {{.Replicas}}
  selector:
    matchLabels:
      name: {{.Name}}
  template:
    metadata:
      labels:
        name: {{.Name}}
        group: {{.Group}}
    spec:
      nodeSelector:
        role: worker
      containers:
      - image: k8s.gcr.io/pause:3.1
        imagePullPolicy: IfNotPresent
        name: {{.Name}}
        ports:
        resources:
          requests:
            cpu: {{.CpuRequest}}
            memory: {{.MemoryRequest}}
      # Add not-ready/unreachable tolerations for 15 minutes so that node
      # failure doesn't trigger pod deletion.
      tolerations:
      - key: "node.kubernetes.io/not-ready"
        operator: "Exists"
        effect: "NoExecute"
        tolerationSeconds: 900
      - key: "node.kubernetes.io/unreachable"
        operator: "Exists"
        effect: "NoExecute"
        tolerationSeconds: 900
EOF

cat > "${TEST_CONFIG}"<<'EOF'
# ASSUMPTIONS:
# - Underlying cluster should have 100+ nodes.
# - Number of nodes should be divisible by NODES_PER_NAMESPACE (default 100).

#Constants
{{$DENSITY_RESOURCE_CONSTRAINTS_FILE := DefaultParam .DENSITY_RESOURCE_CONSTRAINTS_FILE ""}}
{{$NODE_MODE := DefaultParam .NODE_MODE "allnodes"}}
#{{$NODES_PER_NAMESPACE := DefaultParam .NODES_PER_NAMESPACE 100}}
{{$NODES_PER_NAMESPACE := DefaultParam .NODES_PER_NAMESPACE 3}} # wardenlym: only 4 worker node
#{{$PODS_PER_NODE := DefaultParam .PODS_PER_NODE 30}}
{{$PODS_PER_NODE := DefaultParam .PODS_PER_NODE 10}} # wardenlym: only 10 pod
{{$DENSITY_TEST_THROUGHPUT := DefaultParam .DENSITY_TEST_THROUGHPUT 20}}
{{$SCHEDULER_THROUGHPUT_THRESHOLD := DefaultParam .CL2_SCHEDULER_THROUGHPUT_THRESHOLD 0}}
# LATENCY_POD_MEMORY and LATENCY_POD_CPU are calculated for 1-core 4GB node.
# Increasing allocation of both memory and cpu by 10%
# decreases the value of priority function in scheduler by one point.
# This results in decreased probability of choosing the same node again.
{{$LATENCY_POD_CPU := DefaultParam .LATENCY_POD_CPU 1}}
{{$LATENCY_POD_MEMORY := DefaultParam .LATENCY_POD_MEMORY 30}}
#{{$MIN_LATENCY_PODS := DefaultParam .MIN_LATENCY_PODS 500}}
{{$MIN_LATENCY_PODS := DefaultParam .MIN_LATENCY_PODS 30}} # wardenlym only 20
{{$MIN_SATURATION_PODS_TIMEOUT := 180}}
{{$ENABLE_CHAOSMONKEY := DefaultParam .ENABLE_CHAOSMONKEY false}}
{{$ENABLE_PROMETHEUS_API_RESPONSIVENESS := DefaultParam .ENABLE_PROMETHEUS_API_RESPONSIVENESS false}}
{{$ENABLE_SYSTEM_POD_METRICS:= DefaultParam .ENABLE_SYSTEM_POD_METRICS true}}
{{$ENABLE_CLUSTER_OOMS_TRACKER := DefaultParam .CL2_ENABLE_CLUSTER_OOMS_TRACKER false}}
{{$CLUSTER_OOMS_IGNORED_PROCESSES := DefaultParam .CL2_CLUSTER_OOMS_IGNORED_PROCESSES ""}}
{{$USE_SIMPLE_LATENCY_QUERY := DefaultParam .USE_SIMPLE_LATENCY_QUERY false}}
{{$ENABLE_RESTART_COUNT_CHECK := DefaultParam .ENABLE_RESTART_COUNT_CHECK false}}
{{$RESTART_COUNT_THRESHOLD_OVERRIDES:= DefaultParam .RESTART_COUNT_THRESHOLD_OVERRIDES ""}}
{{$ALLOWED_SLOW_API_CALLS := DefaultParam .CL2_ALLOWED_SLOW_API_CALLS 0}}
{{$ENABLE_VIOLATIONS_FOR_SCHEDULING_THROUGHPUT := DefaultParam .CL2_ENABLE_VIOLATIONS_FOR_SCHEDULING_THROUGHPUT true}}
#Variables
{{$namespaces := DivideInt .Nodes $NODES_PER_NAMESPACE}}
{{$podsPerNamespace := MultiplyInt $PODS_PER_NODE $NODES_PER_NAMESPACE}}
{{$totalPods := MultiplyInt $podsPerNamespace $namespaces}}
{{$latencyReplicas := DivideInt (MaxInt $MIN_LATENCY_PODS .Nodes) $namespaces}}
{{$totalLatencyPods := MultiplyInt $namespaces $latencyReplicas}}
{{$saturationDeploymentTimeout := DivideFloat $totalPods $DENSITY_TEST_THROUGHPUT | AddInt $MIN_SATURATION_PODS_TIMEOUT}}
# saturationDeploymentHardTimeout must be at least 20m to make sure that ~10m node
# failure won't fail the test. See https://github.com/kubernetes/kubernetes/issues/73461#issuecomment-467338711
{{$saturationDeploymentHardTimeout := MaxInt $saturationDeploymentTimeout 1200}}

{{$saturationDeploymentSpec := DefaultParam .SATURATION_DEPLOYMENT_SPEC "deployment.yaml"}}
{{$latencyDeploymentSpec := DefaultParam .LATENCY_DEPLOYMENT_SPEC "deployment.yaml"}}

# Probe measurements shared parameter
{{$PROBE_MEASUREMENTS_CHECK_PROBES_READY_TIMEOUT := DefaultParam .CL2_PROBE_MEASUREMENTS_CHECK_PROBES_READY_TIMEOUT "5m"}}

name: density
namespace:
  number: {{$namespaces}}
tuningSets:
- name: Uniform5qps
  qpsLoad:
    qps: 5
{{if $ENABLE_CHAOSMONKEY}}
chaosMonkey:
  nodeFailure:
    failureRate: 0.01
    interval: 1m
    jitterFactor: 10.0
    simulatedDowntime: 10m
{{end}}
steps:
- name: Starting measurements
  measurements:
  - Identifier: APIResponsivenessPrometheus
    Method: APIResponsivenessPrometheus
    Params:
      action: start
  - Identifier: APIResponsivenessPrometheusSimple
    Method: APIResponsivenessPrometheus
    Params:
      action: start
  # TODO(oxddr): figure out how many probers to run in function of cluster
  - Identifier: InClusterNetworkLatency
    Method: InClusterNetworkLatency
    Params:
      action: start
      checkProbesReadyTimeout: {{$PROBE_MEASUREMENTS_CHECK_PROBES_READY_TIMEOUT}}
      replicasPerProbe: {{AddInt 2 (DivideInt .Nodes 100)}}
  - Identifier: DnsLookupLatency
    Method: DnsLookupLatency
    Params:
      action: start
      checkProbesReadyTimeout: {{$PROBE_MEASUREMENTS_CHECK_PROBES_READY_TIMEOUT}}
      replicasPerProbe: {{AddInt 2 (DivideInt .Nodes 100)}}
  - Identifier: TestMetrics
    Method: TestMetrics
    Params:
      action: start
      nodeMode: {{$NODE_MODE}}
      resourceConstraints: {{$DENSITY_RESOURCE_CONSTRAINTS_FILE}}
      systemPodMetricsEnabled: {{$ENABLE_SYSTEM_POD_METRICS}}
      clusterOOMsTrackerEnabled: {{$ENABLE_CLUSTER_OOMS_TRACKER}}
      clusterOOMsIgnoredProcesses: {{$CLUSTER_OOMS_IGNORED_PROCESSES}}
      restartCountThresholdOverrides: {{YamlQuote $RESTART_COUNT_THRESHOLD_OVERRIDES 4}}
      enableRestartCountCheck: {{$ENABLE_RESTART_COUNT_CHECK}}

- name: Starting saturation pod measurements
  measurements:
  - Identifier: SaturationPodStartupLatency
    Method: PodStartupLatency
    Params:
      action: start
      labelSelector: group = saturation
      threshold: {{$saturationDeploymentTimeout}}s
  - Identifier: WaitForRunningSaturationDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: start
      apiVersion: apps/v1
      kind: Deployment
      labelSelector: group = saturation
      operationTimeout: {{$saturationDeploymentHardTimeout}}s
  - Identifier: SchedulingThroughput
    Method: SchedulingThroughput
    Params:
      action: start
      labelSelector: group = saturation

- name: Creating saturation pods
  phases:
  - namespaceRange:
      min: 1
      max: {{$namespaces}}
    replicasPerNamespace: 1
    tuningSet: Uniform5qps
    objectBundle:
    - basename: saturation-deployment
      objectTemplatePath: {{$saturationDeploymentSpec}}
      templateFillMap:
        Replicas: {{$podsPerNamespace}}
        Group: saturation
        CpuRequest: 1m
        MemoryRequest: 10M

- name: Waiting for saturation pods to be running
  measurements:
  - Identifier: WaitForRunningSaturationDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: gather

- name: Collecting saturation pod measurements
  measurements:
  - Identifier: SaturationPodStartupLatency
    Method: PodStartupLatency
    Params:
      action: gather
  - Identifier: SchedulingThroughput
    Method: SchedulingThroughput
    Params:
      action: gather
      enableViolations: {{$ENABLE_VIOLATIONS_FOR_SCHEDULING_THROUGHPUT}}
      threshold: {{$SCHEDULER_THROUGHPUT_THRESHOLD}}

- name: Starting latency pod measurements
  measurements:
  - Identifier: PodStartupLatency
    Method: PodStartupLatency
    Params:
      action: start
      labelSelector: group = latency
  - Identifier: WaitForRunningLatencyDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: start
      apiVersion: apps/v1
      kind: Deployment
      labelSelector: group = latency
      operationTimeout: 15m

- name: Creating latency pods
  phases:
  - namespaceRange:
      min: 1
      max: {{$namespaces}}
    replicasPerNamespace: {{$latencyReplicas}}
    tuningSet: Uniform5qps
    objectBundle:
    - basename: latency-deployment
      objectTemplatePath: {{$latencyDeploymentSpec}}
      templateFillMap:
        Replicas: 1
        Group: latency
        CpuRequest: {{$LATENCY_POD_CPU}}m
        MemoryRequest: {{$LATENCY_POD_MEMORY}}M

- name: Waiting for latency pods to be running
  measurements:
  - Identifier: WaitForRunningLatencyDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: gather

- name: Deleting latency pods
  phases:
  - namespaceRange:
      min: 1
      max: {{$namespaces}}
    replicasPerNamespace: 0
    tuningSet: Uniform5qps
    objectBundle:
    - basename: latency-deployment
      objectTemplatePath: {{$latencyDeploymentSpec}}

- name: Waiting for latency pods to be deleted
  measurements:
  - Identifier: WaitForRunningLatencyDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: gather

- name: Collecting pod startup latency
  measurements:
  - Identifier: PodStartupLatency
    Method: PodStartupLatency
    Params:
      action: gather

- name: Deleting saturation pods
  phases:
  - namespaceRange:
      min: 1
      max: {{$namespaces}}
    replicasPerNamespace: 0
    tuningSet: Uniform5qps
    objectBundle:
    - basename: saturation-deployment
      objectTemplatePath: {{$saturationDeploymentSpec}}

- name: Waiting for saturation pods to be deleted
  measurements:
  - Identifier: WaitForRunningSaturationDeployments
    Method: WaitForControlledPodsRunning
    Params:
      action: gather

- name: Collecting measurements
  measurements:
  - Identifier: APIResponsivenessPrometheusSimple
    Method: APIResponsivenessPrometheus
    Params:
      action: gather
      enableViolations: true
      useSimpleLatencyQuery: true
      summaryName: APIResponsivenessPrometheus_simple
      allowedSlowCalls: {{$ALLOWED_SLOW_API_CALLS}}
  {{if not $USE_SIMPLE_LATENCY_QUERY}}
  - Identifier: APIResponsivenessPrometheus
    Method: APIResponsivenessPrometheus
    Params:
      action: gather
      allowedSlowCalls: {{$ALLOWED_SLOW_API_CALLS}}
  {{end}}
  - Identifier: InClusterNetworkLatency
    Method: InClusterNetworkLatency
    Params:
      action: gather
  - Identifier: DnsLookupLatency
    Method: DnsLookupLatency
    Params:
      action: gather
  - Identifier: TestMetrics
    Method: TestMetrics
    Params:
      action: gather
      systemPodMetricsEnabled: {{$ENABLE_SYSTEM_POD_METRICS}}
      clusterOOMsTrackerEnabled: {{$ENABLE_CLUSTER_OOMS_TRACKER}}
      restartCountThresholdOverrides: {{YamlQuote $RESTART_COUNT_THRESHOLD_OVERRIDES 4}}
      enableRestartCountCheck: {{$ENABLE_RESTART_COUNT_CHECK}}
EOF

$CLUSTER_LOADER --provider=$PROVIDER \
    --kubeconfig=$KUBE_CONFIG \
    --mastername=$MASTER_NAME \
    --masterip=$MASTER_IP \
    --master-internal-ip=$MASTER_INTERNAL_IP \
    --testconfig=$TEST_CONFIG \
    --report-dir=$REPORT_DIR \
    --alsologtostderr --v=3 2>&1 | tee $LOG_FILE
