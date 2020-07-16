echo "creating docker volume folders..."
mkdir mqtt_microservices/mongodb
mkdir swarmpit/db-data
mkdir swarmpit/influxdb-data
mkdir pihole/etc-pihole
mkdir pihole/etc-dnsmasq.d
mkdir mqtt_microservices/chronograf

echo "Creating docker volumes..."
docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/pihole/etc-pihole \
      piholevolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/pihole/etc-dnsmasq.d \
      dnsvolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/chronograf \
      chronografvolume

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/swarmpit/db-data \
      dbdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/swarmpit/influxdb-data \
      influxdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96 \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/mosquitto/mosquitto.conf \
      mqttconf

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/mongodb \
      mongodbdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/telegraf \
      telegrafdata

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/influxdb/db \
      mqttinfluxdb

docker volume create --driver local \
      --opt type=nfs \
      --opt o=nfsvers=4,addr=10.0.0.96,rw \
      --opt device=:/home/ubuntu/PI4Server/mqtt_microservices/influxdb/influxdb.conf \
      mqttinfluxconf

echo "Deploying swarmpit stack"
docker stack deploy -c swarmpit/docker-compose.yml swarmpit
echo "Deploying mqtt microservices stack"
docker stack deploy -c mqtt_microservices/mqtt-stack.yml mqtt_microservices
#echo "Deploying traefik stack"
#docker stack deploy -c traefik/traefik-stack.yml traefik
