remember to change hostname on everynode to avoid duplicate names

node password:
/var/lib/rancher/k3s/agent/node-password.txt

Master passwords:
/var/lib/rancher/k3s/server/cred/node-passwd
## to reset k3s:
 sudo /usr/local/bin/k3s-killall.sh
