Vagrant OpenLDAP VM
===================

Create a simple VM with [OpenLDAP](http://www.openldap.org/) to helper development and tests.

It will install the [phpldapadmin](http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page)


Installation
------------

Install [Vagrant](http://www.vagrantup.com/).

It will need some plugins too:
* [landrush](hhttps://github.com/vagrant-landrush/landrush)

To install run the following command: `sudo vagrant plugin install landrush`

Clonning this repository: `git clone https://github.com/chulao/vagrant-ldap.git`

This project is using these modules:
* [stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* [datacentred/ldap](https://forge.puppet.com/datacentred/ldap)
* [spantree/phpldapadmin](https://forge.puppet.com/spantree/phpldapadmin)

Before create vm, please, check if landrush can running without error:
```
vagrant landrush start

ps -ef | grep `cat ~/.vagrant.d/data/landrush/run/landrush.pid`
```

Then, create the machine `vagrant up`

To test if ldap is ready execute `ldapsearch -x -LLL -v -h ldap.vagrant.dev -D cn=admin,dc=vagrant,dc=dev -w admin -b dc=vagrant,dc=dev`. The return should be similar as:
```
ldap_initialize( ldap://ldap.vagrant.dev )
filter: (objectclass=*)
requesting: All userApplication attributes
dn: dc=vagrant,dc=dev
dc: vagrant
objectClass: top
objectClass: domain
description: Tree root

dn: cn=admin,dc=vagrant,dc=dev
cn: admin
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
uid: admin
sn: admin
userPassword:: e1NIQX0wRFBpS3VOSXJyVm1EOElVQ3V3MWhReE5xWmM9
```

After the machine is running you can access it by:
* http://ldap.vagrant.dev/phpldapadmin
* `ldapsearch -x -h ldap.vagrant.dev -D "cn=admin,dc=vagrant,dc=dev" -w admin -b "dc=vagrant,dc=dev" "(cn=*)"`

> To change the ldap information, please see **puppet/data/common.yaml**

To log in, using :
Username: `cn=admin,dc=vagrant,dc=dev`
Password: `admin`


Troubleshoot
------------

### Run in debug mode
```
vagrant up --debug &> vagrant.log
```

### Discovery guest machine ip
```
vagrant ssh -c "ip addr show eth1 | grep 'inet' | grep 'eth1' | sed -e 's/^.*inet //' -e 's/\/.*$//'"
```

### Hostname is listed in DNS (landrush), but will not resolve
If the **landrush** is show the correct ip through `vagrant landrush ls`, but with other commands, like `ping`, it is not resolving on OSX, please, restart *mDNSResponder*: `sudo killall -HUP mDNSResponder`


### Failed to mount folders in Linux guest. This is usually because the "vboxsf" file system is not available.

Step by step:

If you not have vbguest plugin, install it: `vagrant plugin install vagrant-vbguest`

Run Vagrant: `vagrant up`

Login on VM: `vagrant ssh`

In the guest: `sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions`

Back on the host, reload Vagrant: `vagrant reload`

Referencies:
* [Vagrant can't mount shared folder in VirtualBox 4.3.10](https://github.com/mitchellh/vagrant/issues/3341)
* [Vagrant landrush DNS plugin tips and troubleshooting](https://gist.github.com/neuroticnerd/30b12648a933677ad2c4)