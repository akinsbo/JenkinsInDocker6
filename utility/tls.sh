HOST=olaolu
IPADDRESS=197.149.119.246
echo 'creating directory to store keys to be generated'
cd ~
sudo mkdir .docker
cd .docker
# Create the CA key
sudo openssl genrsa -aes256 -out ca-key.pem 4096
sudo openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
# Create the server key by running the following commands
sudo openssl genrsa -out server-key.pem 4096
sudo openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = IP:$IPADDRESS,IP:127.0.0.1 > extfile.cnf
sudo openssl x509 -req -days 365 -sha256 -in server.csr \
-CA ca.pem -CAkey ca-key.pem -CAcreateserial \
-out server-cert.pem -extfile extfile.cnf
#Create the client key
sudo openssl genrsa -out key.pem 4096
sudo openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
sudo openssl x509 -req -days 365 -sha256 -in client.csr \
-CA ca.pem -CAkey ca-key.pem -CAcreateserial \
-out cert.pem -extfile extfile.cnf

sudo mv ca-key.pem ca-key.bak
sudo mv key.pem key.bak
sudo openssl rsa -in ca-key.bak -text > ca-key.pem
sudo openssl rsa -in key.bak -text > key.pem
# remove .bak files that are no longer necessary
sudo rm ca-key.bak key.bak extfile.cnf
# remove certificate signing requests that are no longer needed
sudo rm -v client.csr server.csr
# protect the keys by assigning the permissions
sudo chmod -v 0400 ca-key.pem key.pem server-key.pem
sudo chmod -v 0444 ca.pem server-cert.pem cert.pem

#Create and configure the docker.conf file
sudo mkdir /etc/systemd/system/docker.service.d
sudo vim /etc/systemd/system/docker.service.d/docker.conf
#COPY the following into it
#[Service]
#ExecStart=
#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376
sudo vim /etc/docker/daemon.json
#Create and configure the daemon.conf file, COPY the following into it
#{
# "tls": true,
# "tlsverify": true,
# "tlscacert": "/home/spacely-eng-admin/.docker/ca.pem",
# "tlscert": "/home/spacely-eng-admin/.docker/server-cert.pem",
# "tlskey": "/home/spacely-eng-admin/.docker/server-key.pem",
# "dns": ["8.8.8.8", "8.8.4.4"]
#}
sudo vim /lib/systemd/system/docker.service
#Scroll down and find the line ExecStart=/usr/bin/dockerd -H fd://.
#Remove -H fd:// from the line and save.

#Reload and restart docker
sudo service docker stop
#Then enter the next command:
sudo systemctl daemon-reload
#Then enter the next command:
sudo service docker start