kubectl label nodes worker-01 role=worker
kubectl label nodes worker-02 role=worker
kubectl label nodes worker-03 role=worker

kubectl get nodes --show-labels

deployment.yaml增加
```
    spec:
      nodeSelector:
        role: worker
```

需要image

k8s.gcr.io/pause:3.1
gcr.io/kubernetes-e2e-test-images/agnhost:2.2


build clusterloader2

git clone https://github.com/kubernetes/perf-tests
cd perf-tests && git checkout release-1.19
cd clusterloader2/cmd && go build -o clusterloader

