sudo apt update -y
sudo apt upgrade -y
sudo apt install -y docker.io
#maybe install docker too? idk the difference...
sudo apt install -y git

#ensure user has right to access docker
usermod ubuntu -aG docker

sudo apt-get install -y libffi-dev libssl-dev
sudo apt-get install -y python3 python3-pip

#open faas cli
curl -sLfS https://cli.openfaas.com | sudo sh

#create pihole folders
mkdir /home/ubuntu/PI4Server/pihole/
mkdir /home/ubuntu/PI4Server/pihole/etc-pihole
mkdir /home/ubuntu/PI4Server/pihole/etc-dnsmasq.d

#create B4åæp¨weinfluxdb folder
mkdir /home/ubuntu/PI4Server/influxdb/db

#create swarmpit foldersk
mkdir /home/ubuntu/PI4Server/swarmpit/db-data
mkdir /home/ubuntu/PI4Server/swarmpit/influxdb-data
