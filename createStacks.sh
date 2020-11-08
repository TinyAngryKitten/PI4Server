export rootFolder=/mnt/raidstorage/rpidata #/home/ubuntu/PI4Server
export keyPath=/Users/sanderhoyvik/Keys/sshkey

echo "creating docker volume folders..."

ssh -p 22 -i $keyPath ubuntu@10.0.0.96 << EOF
mkdir $rootFolder/mqtt_microservices/mongodb
mkdir $rootFolder/swarmpit/db-data
mkdir $rootFolder/swarmpit/influxdb-data
mkdir $rootFolder/pihole/etc-pihole
mkdir $rootFolder/pihole/etc-dnsmasq.d
mkdir $rootFolder/mqtt_microservices/chronograf
mkdir $rootFolder/homebridge/data
EOF

echo "Connecting to remote docker host"
eval $(docker-machine env pi4Cluster)

echo "Create docker resources"
#Create a network that dont overlap with the local network
docker network create \
    --driver overlay \
    --ingress \
    --subnet 172.16.0.0/16 \
    --gateway 172.16.0.1 \
    ingress

echo "Creating docker volumes..."
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/pihole/etc-pihole \
      piholevolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/traefik \
      traefikvolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/pihole/etc-dnsmasq.d \
      dnsvolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/chronograf \
      chronografvolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/swarmpit/db-data \
      dbdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/swarmpit/influxdb-data \
      influxdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/mosquitto/mosquitto.conf \
      mqttconf

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/mongodb \
      mongodbdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/telegraf \
      telegrafdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/influxdb/db \
      mqttinfluxdb

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:$rootFolder/mqtt_microservices/influxdb \
      mqttinfluxconf

docker pull tinyangrykitten/hueserver:latest
docker pull tinyangrykitten/livegamenotification:latest
docker pull tinyangrykitten/wakeonlan:latest
docker pull tinyangrykitten/notifications:latest
docker pull tinyangrykitten/harmonyhub-server:latest

echo "Deploying swarmpit stack"
docker stack deploy -c swarmpit/docker-compose.yml swarmpit
echo "Deploying mqtt microservices stack"
docker stack deploy -c mqtt_microservices/mqtt-stack.yml mqtt_microservices
echo "Deploying traefik stack"
docker stack deploy -c traefik/traefik-stack.yml traefik
echo "Deplying shepherd stack"
docker stack deploy -c shepherd/shepherd-stack.yml shepherd
echo "Deploying microservices stack"
docker stack deploy -c pimicroservices/pimicroservices-stack.yml microservices
