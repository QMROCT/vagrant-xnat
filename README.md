# Vagrant XNAT

Provision Ubuntu 14.04 based Vagrant box with XNAT 1.6.5


### Dependencies:
* VirtualBox
* Vagrant

### Installation:
```bash
cd vagrant-xnat
vagrant up
```

Once the Vagrant box is up and running XNAT is available at http://192.168.50.50:8080/xnat

### Change IP address of Vagrant box:
* Change xdat.url option in build.properties
* Change config.vm.network option in Vagrantfile
