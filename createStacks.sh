mkdir mqtt_microservices/mongodb
mkdir swarmpit/db-data
mkdir swarmpit/influxdb-data
mkdir pihole/etc-pihole
mkdir pihole/etc-dnsmasq.d

docker network create --driver=overlay proxy

docker stack deploy -c swarmpit/docker-compose.yml swarmpit
docker stack deploy -c mqtt_microservices/mqtt-stack.yml mqtt_microservices
