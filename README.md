vagrant-xnat
============

Provision Ubuntu 14.04 based Vagrant box with XNAT<br/><br/>
Project is NO LONGER SUPPORTED, since the XNAT developers started a <a href="https://bitbucket.org/nrg/xnat_vagrant_1_6dev/overview">similar project</a> with their 1.6.5 release.

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

### Author:
Christoph Jansen, HTW Berlin<br/>
https://github.com/QMROCT/vagrant-xnat
