#https://vitux.com/install-nfs-server-and-client-on-ubuntu/
export FILESERVER=192.168.50.3

sudo mkdir -p /mnt/raidstorage/rpidata
sudo mount $FILESERVER:/mnt/raidstorage/rpidata  /mnt/raidstorage/rpidata
