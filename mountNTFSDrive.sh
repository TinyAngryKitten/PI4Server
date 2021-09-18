#https://vitux.com/install-nfs-server-and-client-on-ubuntu/
export FILESERVER=192.168.50.3

sudo mkdir -p /mnt/bigstorage/rpidata
sudo mount $FILESERVER:/mnt/bigstorage/rpidata  /mnt/bigstorage/rpidata
