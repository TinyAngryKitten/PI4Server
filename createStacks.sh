#docker stack deploy -c swarmpit/docker-compose.yml swarmpit
docker stack deploy -c mqtt-stack.yml mqtt
sh faas/deploy_stack.sh --no-auth
