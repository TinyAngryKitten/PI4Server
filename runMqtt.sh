docker run -it \
 -p 1883:1883 -p 9001:9001 \
 -v /home/pi/PI4Server/mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf \
 --name mosquitto \
 eclipse-mosquitto
