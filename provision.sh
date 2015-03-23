vag#!/bin/bash

XNAT=xnat-1.6.4

# create tomcat7 user
sudo useradd -g users -d /home/tomcat7 -s /bin/bash tomcat7
sudo groupadd tomcat7
sudo usermod -a -G tomcat7 tomcat7
sudo mkdir /home/tomcat7
sudo chown -R tomcat7:tomcat7 /home/tomcat7

# create xnat database user
sudo useradd -g users xnat01

# install dependencies
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install postgresql
sudo apt-get -y install openjdk-7-jdk
sudo apt-get -y install tomcat7

# download xnat
cd /opt
sudo curl -O ftp://ftp.nrg.wustl.edu/pub/xnat/${XNAT}.tar.gz
sudo tar -zxvf ${XNAT}.tar.gz
sudo cp /vagrant/build.properties /opt/${XNAT}

# database settings
sudo -u postgres createuser -U postgres -S -D -R xnat01
sudo -u postgres psql -U postgres -c "ALTER USER xnat01 WITH PASSWORD 'xnat'"
sudo -u postgres createdb -U postgres -O xnat01 xnat

# create data dir
sudo mkdir /opt/data
sudo chown -R tomcat7:tomcat7 /opt/data

# xnat installation
sudo service tomcat7 stop
sudo chown -R tomcat7:tomcat7 /vagrant/build.properties
sudo chown -R tomcat7:tomcat7 /opt/${XNAT}
sudo chmod -R 777 /opt/${XNAT}
cd /opt/${XNAT}
sudo su tomcat7 -c "echo 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> /home/tomcat7/.bashrc"
sudo su tomcat7 -c "echo 'export PATH=\${PATH}:/opt/${XNAT}/bin' >> /home/tomcat7/.bashrc"
sudo su tomcat7 -c "source ~/.bashrc && bin/setup.sh -Ddeploy=true"
cd deployments/xnat
sudo -u xnat01 psql -d xnat -f sql/xnat.sql -U xnat01
sudo su tomcat7 -c "source ~/.bashrc && StoreXML -l security/security.xml -allowDataDeletion true"
sudo su tomcat7 -c "source ~/.bashrc && StoreXML -dir ./work/field_groups -u admin -p admin -allowDataDeletion true"
sudo service tomcat7 start
