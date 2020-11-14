eval $(docker-machine env pi4Cluster)

docker exec mqtt_microservices_kapacitor_1 sh -c "cd /home/kapacitor && kapacitor define bathroom_temp -type stream -tick ./bathroom_temp.tick -dbrp sensordata.autogen"
docker exec mqtt_microservices_kapacitor_1 sh -c "kapacitor enable bathroom_temp"

docker exec mqtt_microservices_kapacitor_1 sh -c "cd /home/kapacitor && kapacitor define bathroom_humidity -type stream -tick ./bathroom_humidity.tick -dbrp sensordata.autogen"
docker exec mqtt_microservices_kapacitor_1 sh -c "kapacitor enable bathroom_humidity"
