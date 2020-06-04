sudo docker run -d -p 8086:8086 \
      -e INFLUXDB_DB=sensordata \
      -e INFLUXDB_USER=telegraf -e INFLUXDB_USER_PASSWORD=telegraf \
      -v /home/pi/PI4Server/influxdb/db:/var/lib/influxdb \
      -v /home/pi/PI4Server/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      --name influxdb influxdb
