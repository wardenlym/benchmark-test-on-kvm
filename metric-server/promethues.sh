kubectl label worker-04 role=monitor

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo add grafana https://grafana.github.io/helm-charts

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitor --version 13.13.1


grafana/grafana:7.4.2
k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8
quay.io/kiwigrid/k8s-sidecar:1.10.6
quay.io/prometheus/alertmanager:v0.21.0
quay.io/prometheus/node-exporter:v1.0.1
quay.io/prometheus-operator/prometheus-config-reloader:v0.45.0
quay.io/prometheus-operator/prometheus-operator:v0.45.0
quay.io/prometheus/prometheus:v2.24.0

docker pull grafana/grafana:7.4.2
docker pull k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8
docker pull quay.io/kiwigrid/k8s-sidecar:1.10.6
docker pull quay.io/prometheus/alertmanager:v0.21.0
docker pull quay.io/prometheus/node-exporter:v1.0.1
docker pull quay.io/prometheus-operator/prometheus-config-reloader:v0.45.0
docker pull quay.io/prometheus-operator/prometheus-operator:v0.45.0
docker pull quay.io/prometheus/prometheus:v2.24.0

docker save -o monitor-images.tgz \
grafana/grafana:7.4.2 \
k8s.gcr.io/kube-state-metrics/kube-state-metrics:v1.9.8 \
quay.io/kiwigrid/k8s-sidecar:1.10.6 \
quay.io/prometheus/alertmanager:v0.21.0 \
quay.io/prometheus/node-exporter:v1.0.1 \
quay.io/prometheus-operator/prometheus-config-reloader:v0.45.0 \
quay.io/prometheus-operator/prometheus-operator:v0.45.0 \
quay.io/prometheus/prometheus:v2.24.0