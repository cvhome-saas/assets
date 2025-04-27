#!/bin/bash
if [ $(id -u) -ne 0 ]
  then echo Please run this script as root or using sudo!
  exit
fi

function append() {
    text=$1
    file=$2
    if grep  "$text" "$file" &> /dev/null; then
      echo "exists" &> /dev/null
    else
      echo -e  "\n$text" | sudo tee -a "$file" &> /dev/null
    fi

}


function run-append() {
    file="/etc/hosts"
    append "127.0.0.1 gateway.com" "$file"
    append "127.0.0.1 www.gateway.com" "$file"
    append "127.0.0.1 auth.gateway.com" "$file"
    append "127.0.0.1 store-ui.gateway.com" "$file"
    append "127.0.0.1 welcome-ui.gateway.com" "$file"
    append "127.0.0.1 store-pod-1.gateway.com" "$file"
    append "127.0.0.1 merchant-ui.gateway.com" "$file"
    append "127.0.0.1 org1-store1.store-pod-saas-gateway-1.gateway.com" "$file"
    append "127.0.0.1 org1-store2.store-pod-saas-gateway-1.gateway.com" "$file"
    append "127.0.0.1 org2-store1.store-pod-saas-gateway-1.gateway.com" "$file"
    append "127.0.0.1 org2-store2.store-pod-saas-gateway-1.gateway.com" "$file"
}

function pull-images() {
  docker pull rabbitmq:4.0.2-management
  docker pull postgres:15-alpine
  docker pull bitnami/minio
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/auth:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/merchant:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/content:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/catalog:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/order:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/landing-ui:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/merchant-ui:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/store-pod-gateway:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-pod/store-pod-saas-gateway:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/manager:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/subscription:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/store-ui:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/welcome-ui:develop-0.2.13-14690254909-SNAPSHOT
  docker pull public.ecr.aws/g0a5h6c1/1691275173/store-core/store-core-gateway:develop-0.2.13-14690254909-SNAPSHOT
}

 run-append
 pull-images
 wget https://raw.githubusercontent.com/cvhome-saas/assets/refs/heads/main/fast-run/docker-compose.yml