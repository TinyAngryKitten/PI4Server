sudo docker stop traefik
sudo docker rm traefik
sudo docker stop chronograf
sudo docker rm chronograf

docker network create traefik

docker run -d \
  -v /home/ubuntu/PI4Server/mqtt_microservices/chronograf:/var/lib/chronograf \
  -p 8888:8888 \
  -l traefik.enable=true \
  -l traefik.frontend.rule=PathPrefixStrip:/chronograf \
  -l traefik.port=8888 \
  -l traefik.backend=mqtt.chronograf \
  -l docker.network=traefik \
  -l traefik.http.services.chronograf.loadbalancer.server.port=8888 \
  --network traefik \
  --name chronograf \
  chronograf:1.8

  #-v $PWD/traefik.toml:/traefik.toml \
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  -l traefik.port=8080 \
  -l api=true \
  -l api.dashboard=true \
  -l docker=true \
  -l docker.exposedbydefault=true \
  -l docker.network=traefik \
  -l consulcatalog=true \
  -l consulcatalog.endpoint=10.0.0.96:8500 \
  -l consulcatalog.exposedByDefault=true \
  -l traefik.enable=true \
  -l traefik.http.routers.api.rule=Host(`traefik.localhost`) \
  -l traefik.http.routers.api.service=api@internal \
  -l traefik.http.services.traefik.loadbalancer.server.port=8080 \
  --network traefik \
  --name traefik \
  traefik:1.7.2
