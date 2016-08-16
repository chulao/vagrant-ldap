$dn = domain2dn("$::domain")
$admin_dn = hiera("ldap::server::rootdn")

$host = hiera("server::host")
$port = hiera("server::port")

node "ldap.vagrant.dev" {
	include stdlib

	include info
	include ldap
	include ldapEntries
	include ldapAdmin
}

class info {
	notify { "welcome":
		message => hiera("welcome_message"),
	}

	notify { "dn":
		message => "Creating LDAP with DN: ${dn}",
	}

	exec { "apt-update":
  		command => "/usr/bin/apt-get update"
	}

	Notify["welcome"] -> Notify["dn"] -> Exec["apt-update"]
}

class ldap {
	require info

	# More information - https://forge.puppet.com/datacentred/ldap/readme
	class { "ldap::server":
	}

	# More information - https://forge.puppet.com/datacentred/ldap/readme
	class { "ldap::client":
	}

	Class["ldap::server"] -> Class["ldap::client"]
}

class ldapEntries {
	require ldap

	$ldap_defaults = {
		ensure 		=> present,
		base   		=> $dn,
		host   		=> $host,
		port   		=> $port,
		ssl    		=> false,
		username    => hiera("ldap::server::rootdn"),
		password    => hiera("ldap::server::rootpw"),
	}

	$password = sha1digest(hiera("ldap::server::rootpw"))

	$ldap_entries = hiera_hash('ldap::entries')
	create_resources('ldap_entry',$ldap_entries,$ldap_defaults)
}

class ldapAdmin {
	require ldap

	# More information - https://forge.puppet.com/spantree/phpldapadmin/readme
	class { 'phpldapadmin':
		ldap_host      => $host,
		ldap_suffix    => hiera("ldap::server::suffix"),
		ldap_bind_id   => hiera("ldap::server::rootdn"),
		ldap_bind_pass => hiera("ldap::server::rootpw"),
		extraconf      => "
			\$servers->newServer('ldap_pla');
			\$servers->SetValue('server','name','LDAP for Dev');
			\$servers->SetValue('server','host','${host}');
			\$servers->SetValue('server','port','${port}');
			\$servers->SetValue('server','base',array('${dn}','cn=config'));
			\$servers->SetValue('login','auth_type','session');
			\$servers->SetValue('login','bind_id','${admin_dn}');
			\$servers->SetValue('server','tls',false);
			\$servers->SetValue('appearance','password_hash_custom','crypt');
			\$servers->SetValue('server','read_only',false);
			\$servers->SetValue('appearance','show_create',true);
			\$servers->SetValue('auto_number','enable',false);"
	}
}