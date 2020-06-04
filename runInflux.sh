sudo docker run -d -p 8086:8086 \
      -e INFLUXDB_DB=sensordata \
      -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=someadminpassword \
      -e INFLUXDB_USER=user -e INFLUXDB_USER_PASSWORD=somepassword \
      -v /home/pi/PI4Server/influxdb/db:/var/lib/influxdb \
      -v /home/pi/PI4Server/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      --name influxdb influxdb
