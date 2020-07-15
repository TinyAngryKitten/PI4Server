docker run -d \
  -v /home/ubuntu/PI4Server/mqtt_microservices/chronograf:/var/lib/chronograf \
  -p 8888:8888 \
  -l traefik.enable=true \
  -l traefik.frontend.rule=PathPrefixStrip:/chronograf \
  -l traefik.port=8888 \
  -l traefik.backend=mqtt.chronograf \
  -l traefik.http.services.chronograf.loadbalancer.server.port=8888 \
  chronograf:1.8

docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  #-v $PWD/traefik.toml:/traefik.toml \
  -p 80:80 \
  -p 443:443 \
  -l traefik.port=8080 \
  -l api=true \
  -l api.dashboard=true \
  -l docker=true \
  -l docker.exposedbydefault=true \
  -l docker.network=proxy \
  -l consulcatalog=true \
  -l consulcatalog.endpoint=10.0.0.96:8500 \
  -l consulcatalog.exposedByDefault=true \
  --network proxy \
  --name traefik \
  traefik:1.7.2
