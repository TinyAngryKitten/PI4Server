


arkade install openfaas --set basic_auth=false
kubectl expose deployments gateway --type=LoadBalancer --name=openfaas-service --namespace=openfaas

arkade install kubernetes-dashboard
#kubectl expose deployments kubernetes-dashboard --type=NodePort --name=dashboard-service --namespace=kubernetes-dashboard

#add helm repos
helm repo add influxdata https://influxdata.github.io/helm-charts
helm repo add halkeye https://halkeye.github.io/helm-charts/
helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

helm install mosquitto halkeye/mosquitto --version 0.1.0 --set service.type=LoadBalancer
helm install influxdb bitnami/influxdb -f influxdb/values.yaml --version 0.5.0
