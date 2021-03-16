kube-proxy默认配置下没数据，需要打开端口
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md#kubeproxy

KubeProxy
The metrics bind address of kube-proxy is default to 127.0.0.1:10249 that prometheus instances cannot access to. You should expose metrics by changing metricsBindAddress field value to 0.0.0.0:10249 if you want to collect them.

Depending on the cluster, the relevant part config.conf will be in ConfigMap kube-system/kube-proxy or kube-system/kube-proxy-config. For example:

kubectl -n kube-system edit cm kube-proxy
apiVersion: v1
data:
  config.conf: |-
    apiVersion: kubeproxy.config.k8s.io/v1alpha1
    kind: KubeProxyConfiguration
    # ...
    # metricsBindAddress: 127.0.0.1:10249
    metricsBindAddress: 0.0.0.0:10249
    # ...
  kubeconfig.conf: |-
    # ...
kind: ConfigMap
metadata:
  labels:
    app: kube-proxy
  name: kube-proxy
  namespace: kube-system