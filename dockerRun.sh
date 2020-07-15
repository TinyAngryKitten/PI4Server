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
  -- network traefik
  chronograf:1.8

  #-v $PWD/traefik.toml:/traefik.toml \
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 80:80 \
  -p 443:443 \
  -l traefik.port=8080 \
  -l api=true \
  -l api.dashboard=true \
  -l docker=true \
  -l docker.exposedbydefault=true \
  -l docker.network=traefik \
  -l consulcatalog=true \
  -l consulcatalog.endpoint=10.0.0.96:8500 \
  -l consulcatalog.exposedByDefault=true \
  --network traefik \
  --name traefik \
  traefik:1.7.2
