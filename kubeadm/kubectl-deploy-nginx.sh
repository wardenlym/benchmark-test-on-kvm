部署一个 Nginx Deployment，包含3个Pod副本
参考：
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment

```
cat > nginx.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
EOF
```
kubectl apply -f nginx.yaml

kubectl expose deployment nginx-deployment --type=NodePort --name=nginx-service

kubernetes集群移除节点
kubectl drain k8snode02 --delete-local-data --force --ignore-daemonsets
kubectl delete node k8snode02

移除集群
kubeadm reset -f
