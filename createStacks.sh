mkdir mqtt_microservices/mongodb
mkdir swarmpit/db-data
mkdir swarmpit/influxdb-data
mkdir pihole/etc-pihole
mkdir pihole/etc-dnsmasq.d
mkdir mqtt_microservices/chronograf

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

docker stack deploy -c swarmpit/docker-compose.yml swarmpit
docker stack deploy -c mqtt_microservices/mqtt-stack.yml mqtt_microservices
