#!/bin/bash

XNAT=xnat-1.6.5

# create tomcat7 user
sudo useradd -g users -d /home/tomcat7 -s /bin/bash tomcat7
sudo groupadd tomcat7
sudo usermod -a -G tomcat7 tomcat7
sudo mkdir /home/tomcat7
sudo chown -R tomcat7:tomcat7 /home/tomcat7

# create xnat database user
sudo useradd -g users xnat01

# install dependencies
sudo apt-get -y install postgresql openjdk-7-jdk tomcat7

# download xnat
cd /opt
sudo curl -O ftp://ftp.nrg.wustl.edu/pub/xnat/${XNAT}.tar.gz
sudo tar -zxvf ${XNAT}.tar.gz
sudo cp /vagrant/build.properties /opt/xnat

# database settings
sudo -u postgres createuser -U postgres -S -D -R xnat01
sudo -u postgres psql -U postgres -c "ALTER USER xnat01 WITH PASSWORD 'xnat'"
sudo -u postgres createdb -U postgres -O xnat01 xnat

# create data directories
sudo mkdir /opt/data
sudo mkdir /opt/data/archive
sudo mkdir /opt/data/prearchive
sudo mkdir /opt/data/cache
sudo mkdir /opt/data/ftp
sudo mkdir /opt/data/build
sudo chown -R tomcat7:tomcat7 /opt/data
sudo chmod -R 770 /opt/data

# xnat installation
sudo service tomcat7 stop
sudo chown -R tomcat7:tomcat7 /opt/xnat
sudo chmod -R 775 /opt/xnat
sudo su tomcat7 -c "echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> /home/tomcat7/.bashrc"
sudo su tomcat7 -c "echo 'export PATH=\${PATH}:/opt/xnat/bin' >> /home/tomcat7/.bashrc"
sudo su tomcat7 -c "source ~/.bashrc && cd /opt/xnat && bin/setup.sh -Ddeploy=true"
sudo -u xnat01 psql -d xnat -f /opt/xnat/deployments/xnat/sql/xnat.sql -U xnat01
sudo su tomcat7 -c "source ~/.bashrc && cd /opt/xnat/deployments/xnat && StoreXML -l security/security.xml -allowDataDeletion true"
sudo su tomcat7 -c "source ~/.bashrc && cd /opt/xnat/deployments/xnat && StoreXML -dir ./work/field_groups -u admin -p admin -allowDataDeletion true"
sudo service tomcat7 start
