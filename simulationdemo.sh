#!/usr/bin/env bash

cd example-deployments/simulation-demo
set -o nounset
set -o errexit

#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#pushd $SCRIPT_DIR && echo "Changed to $SCRIPT_DIR"

echo "Starting rabbitmq"
kubectl apply -f ./rabbitmq/deployment.yaml --kubeconfig /etc/rancher/k3s/k3s.yaml
kubectl apply -f ./rabbitmq/service.yaml --kubeconfig /etc/rancher/k3s/k3s.yaml
echo "Starting redis" 
helm install redis --set auth.enabled=false bitnami/redis --kubeconfig /etc/rancher/k3s/k3s.yaml
echo "Starting minio"  
kubectl apply -f ./minio/deployment.yaml --kubeconfig /etc/rancher/k3s/k3s.yaml
kubectl apply -f ./minio/service.yaml --kubeconfig /etc/rancher/k3s/k3s.yaml
kubectl apply -f ./minio/configmap.yaml --kubeconfig /etc/rancher/k3s/k3s.yaml

#https://hasura.io/blog/using-minikube-as-a-docker-machine-to-avoid-sharing-a-local-registry-bf5020b8197/
minikube ssh docker pull amazon/aws-cli

echo "Creating sogno-platform bucket"
kubectl run --kubeconfig /etc/rancher/k3s/k3s.yaml--rm -i --tty aws-cli --overrides='
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
      "name": "aws-cli"
  },
  "spec": {
    "containers": [
      {
        "name": "aws-cli",
        "command": [ "/root/.aws/setup" ],
        "spacer": [ "bash" ],
        "image": "amazon/aws-cli",
        "stdin": true,
        "stdinOnce": true,
        "tty": true,
        "volumeMounts": [
          {
            "mountPath": "/root/.aws",
            "name": "credentials-volume"
          }
        ]
      }
    ],
    "volumes": [
      {
        "name": "credentials-volume",
        "configMap":
        {
          "name": "aws-config",
          "path": "/root/.aws",
          "defaultMode": 511
        }
      }
    ]
  }
}
'  --image=amazon/aws-cli --restart=Never --


echo "Starting file service" &&
kubectl apply -f ./file-service/deployment.yaml
kubectl apply -f ./file-service/configmap.yaml


echo "Starting dpsim api" &&
helm install dpsim-api sogno/dpsim-api 
echo "Starting dpsim worker" && 
helm install dpsim-worker sogno/dpsim-worker