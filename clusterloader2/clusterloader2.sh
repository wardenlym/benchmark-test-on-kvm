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



	(combined from similar events): Failed to create pod sandbox: rpc error: code = Unknown desc = failed to set up sandbox container "a348d21118f0cf2e2fd0a0c871d4cbabb66054caf32e5ba8da35689dc39450e5" network for pod "latency-deployment-98-6c7cfbf96c-f5kd8": networkPlugin cni failed to set up pod "latency-deployment-98-6c7cfbf96c-f5kd8_test-jf2u41-1" network: error adding host side routes for interface: cali66899ed4a23, error: route (Ifindex: 2451, Dst: 10.44.202.224/32, Scope: 253) already exists for an interface other than 'cali66899ed4a23'