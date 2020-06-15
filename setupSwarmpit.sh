docker run -it --rm \
  --name swarmpit-installer \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /home/ubuntu/PI4Server/swarmpit/db-data:/opt/couchdb/data \
  --volume /home/ubuntu/PI4Server/swarmpit/influxdb-data:/var/lib/influxdb \
  -e INTERACTIVE=0 \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=adminadmin \
  swarmpit/install:1.9
