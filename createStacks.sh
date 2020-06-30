docker stack deploy -c swarmpit/docker-compose.yml swarmpit
docker stack deploy -c mqtt-stack.yml mqtt
cd faas
sh deploy_stack.sh --no-auth
