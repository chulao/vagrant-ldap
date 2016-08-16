Vagrant OpenLDAP VM
===================

Create a simple VM with [OpenLDAP](http://www.openldap.org/) to helper development and tests.

It will install the [phpldapadmin](http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page)


Installation
------------

Install [Vagrant](http://www.vagrantup.com/).

It will need some plugins too:
* [landrush](hhttps://github.com/vagrant-landrush/landrush)

To install run the following command: `sudo puppet plugin install [plugin name]`

Clonning this repository: `git clone https://github.com/chulao/vagrant-ldap.git`

Before create vm, please, check if landrush can running without error:
```
vagrant landrush start

ps -ef | grep `cat ~/.vagrant.d/data/landrush/run/landrush.pid`
```

Then, create the machine `vagrant up`

After the machine is running you can access it by:
* http://ldap.vagrant.dev/phpldapadmin
* `ldapsearch -h ldap.vagrant.dev -D "cn=admin,dc=vagrant,dc=dev" -w admin "(cn=*)"`
> To change the ldap information, please see **puppet/data/common.yaml**

To log in, using :
Username: `cn=admin,dc=vagrant,dc=dev`
Password: `admin`


Troubleshoot
------------

## Run in debug mode
```
vagrant up --debug &> vagrant.log
```

## Failed to mount folders in Linux guest. This is usually because the "vboxsf" file system is not available.

Step by step:

If you not have vbguest plugin, install it: `vagrant plugin install vagrant-vbguest`

Run Vagrant: `vagrant up`

Login on VM: `vagrant ssh`

In the guest: `sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions`

Back on the host, reload Vagrant: `vagrant reload`

Ref. https://github.com/mitchellh/vagrant/issues/3341