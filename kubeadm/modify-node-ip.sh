修改nodeip
1 controlplan join时增加 adviser address 参数

2 vim /var/lib/kubelet/kubeadm-flags.env
  增加 --node-ip=172.29.50.41

kubectl get cs 时controller-manager和scheduler unhealty
  129  vim /etc/kubernetes/manifests/kube-controller-manager.yaml
  130  vim /etc/kubernetes/manifests/kube-scheduler.yaml
注释里面的--port=0
然后systemctl restart kubelet

rancher dashbord 500问题
HTTP Error 500: Internal Server Error
from /k8s/clusters/c-mppz8/v1/schemas

修改nginx config

      map $http_upgrade $conn {
        default "";
        websocket "Upgrade";
      }

    proxy_set_header Upgrade $http_upgrade ;
    proxy_set_header Connection $conn;

```
cat rancher.conf
map $http_upgrade $conn {
    default "";
    websocket "Upgrade";
}
server {
    listen 443 ssl;
    server_name  172.29.40.27;
    ssl_certificate      /etc/nginx/conf.d/cert/https.crt;
    ssl_certificate_key  /etc/nginx/conf.d/cert/https.key;
    ssl_session_timeout  5m;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Accept-Encoding 'gzip';

        ##配置使wss协议生效
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $conn;

        client_max_body_size 2G;
        proxy_pass https://172.29.50.30;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```