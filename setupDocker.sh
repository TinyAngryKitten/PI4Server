sudo apt update -y
sudo apt upgrade -y
sudo apt install -y docker.io
#maybe install docker too? idk the difference...
sudo apt install -y git

#ensure user has right to access docker
usermod ubuntu -aG docker

sudo apt-get install -y libffi-dev libssl-dev
sudo apt-get install -y python3 python3-pip
