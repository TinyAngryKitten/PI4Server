export rootFolder=/mnt/raidstorage/rpidata #/home/ubuntu/PI4Server
export keyPath=/Users/sanderhoyvik/Keys/sshkey
export username=alpha
export masterip=192.168.50.3

echo "creating docker volume folders..."

#echo "transfering files to server"
#scp mqtt_microservices/kapacitor/ticks/* $username@$masterip:/home/ubuntu/ticks/

#ssh -p 22 -i $keyPath ubuntu@$masterip << EOF
#sudo mkdir $rootFolder/swarmpit/db-data
#sudo mkdir $rootFolder/swarmpit/influxdb-data
#sudo mkdir $rootFolder/pihole/etc-pihole
#sudo mkdir $rootFolder/pihole/etc-dnsmasq.d
#sudo mkdir $rootFolder/homebridge/data
#sudo mkdir $rootFolder/mqtt_microservices/mongodb
#sudo mkdir $rootFolder/mqtt_microservices/chronograf
#sudo mkdir $rootFolder/mqtt_microservices/kapacitor
#sudo mkdir $rootFolder/mqtt_microservices/kapacitor/data
#sudo mkdir $rootFolder/mqtt_microservices/kapacitor/ticks
#sudo \cp -rf /home/ubuntu/ticks/* $rootFolder/mqtt_microservices/kapacitor/ticks/
#EOF


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
docker volume rm kapacitortickvolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/kapacitor/data \
      kapacitortickvolume

docker volume rm kapacitordatavolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/kapacitor/ticks \
      kapacitordatavolume

docker volume rm homebridgevolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/homebridge/data \
      homebridgevolume

docker volume rm piholevolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/pihole/etc-pihole \
      piholevolume

docker volume rm dnsvolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/pihole/etc-dnsmasq.d \
      dnsvolume

docker volume rm traefikvolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/traefik \
      traefikvolume

docker volume rm chronografvolume
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mqtt_microservices/chronograf \
      chronografvolume

docker volume rm mqttconf
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mosquitto \
      mqttconf

docker volume rm mongodbdata
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mqtt_microservices/mongodb \
      mongodbdata

docker volume rm telegrafdata
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mqtt_microservices/telegraf \
      telegrafdata

docker volume rm mqttinfluxdb
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mqtt_microservices/influxdb/db \
      mqttinfluxdb

docker volume rm mqttinfluxconf
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=$masterip \
      --opt device=:/mnt/raidstorage/rpidata/mqtt_microservices/influxdb \
      mqttinfluxconf

docker config create traefikconfig traefik/traefik.toml
#docker config create mqttconfig mqtt_microservices/mosquitto/mosquitto.conf

docker pull tinyangrykitten/hueserver:latest
docker pull tinyangrykitten/livegamenotification:latest
docker pull tinyangrykitten/wakeonlan:latest
docker pull tinyangrykitten/notifications:latest
docker pull tinyangrykitten/harmonyhub-server:latest

docker service rm log

echo "Deploying mqtt microservices stack"
docker stack deploy --with-registry-auth -c mqtt_microservices/mqtt-stack.yml mqtt_microservices
echo "Deploying traefik stack"
docker stack deploy --with-registry-auth -c traefik/traefik-stack.yml traefik
echo "Deplying shepherd stack"
docker stack deploy --with-registry-auth -c shepherd/shepherd-stack.yml shepherd
echo "Deploying microservices stack"
docker stack deploy --with-registry-auth -c pimicroservices/pimicroservices-stack.yml microservices
