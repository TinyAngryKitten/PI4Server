export influxdbPass=changethisprobably
export influxdbUsername=admin
export PI4ServerFolder=/Users/sanderhoyvik/Documents/GitHub/PI4Server

arkade install openfaas --set basic_auth=false
kubectl expose deployments gateway --type=LoadBalancer --name=openfaas-service --namespace=openfaas

arkade install kubernetes-dashboard
#kubectl expose deployments kubernetes-dashboard --type=NodePort --name=dashboard-service --namespace=kubernetes-dashboard

#add helm repos
helm repo add influxdata https://influxdata.github.io/helm-charts
helm repo add halkeye https://halkeye.github.io/helm-charts/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://kubernetes-charts.storage.googleapis.com/ #incase stable repo is missing

helm repo update

helm install mosquitto halkeye/mosquitto --version 0.1.0 --set service.type=LoadBalancer
helm install influxdb --namespace mqtt bitnami/influxdb -f $PI4ServerFolder/influxdb/values.yaml --version 0.5.0 --set adminUser.pwd=$influxdbPass

##add influxdb pass to telegraf (this should preferably not be the admin user)
echo '##HTTP Basic Auth' >> $PI4ServerFolder/telegraf/telegraf.conf
echo 'username = "'+$influxdbUsername+'"' >> $PI4ServerFolder/telegraf/telegraf.conf
echo 'password = "'+$influxdbPass+'"' >> $PI4ServerFolder/telegraf/telegraf.conf

helm install telegraf --namespace mqtt influxdata/telegraf -f $PI4ServerFolder/telegraf/values.yaml
