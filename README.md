Vagrant OpenLDAP VM
===================

Create a simple VM with [OpenLDAP](http://www.openldap.org/) to helper development and tests.

It will install the [phpldapadmin](http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page)


Installation
------------

Install [Vagrant](http://www.vagrantup.com/).

To work properly it required the following packages:
* [camptocamp-openldap](https://forge.puppet.com/camptocamp/openldap)
* [spantree-phpldapadmin](https://forge.puppet.com/spantree/phpldapadmin)

To install run the following command: `puppet module install [package name]`

It will need some plugins too:
* [landrush](hhttps://github.com/vagrant-landrush/landrush)

To install run the following command: `puppet plugin install [plugin name]`

Clonning this repository: `git clone https://github.com/chulao/vagrant-ldap.git`

Before create vm, please, check if landrush can running without error:
```
vagrant landrush start

ps -ef | grep `cat ~/.vagrant.d/data/landrush/run/landrush.pid`
```

Then, create the machine `vagrant up`

After the machine is running you can access it by:
* (http://ldap.vagrant.dev/phpldapadmin)[http://ldap.vagrant.dev/phpldapadmin]
* `ldapsearch -h ldap://ldap.vagrant.dev -D "cn=admin,dc=foo,dc=bar" -W "(cn=*)"`

To log in, using :
Username: `cn=admin,dc=vagrant,dc=test`
Password: `admin`


Troubleshoot
------------

## Failed to mount folders in Linux guest. This is usually because the "vboxsf" file system is not available.

Step by step:

If you not have vbguest plugin, install it: `vagrant plugin install vagrant-vbguest`

Run Vagrant: `vagrant up`

Login on VM: `vagrant ssh`

In the guest: `sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions`

Back on the host, reload Vagrant: `vagrant reload`

Ref. [https://github.com/mitchellh/vagrant/issues/3341](https://github.com/mitchellh/vagrant/issues/3341)