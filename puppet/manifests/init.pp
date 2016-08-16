node "ldap.vagrant.dev" {
	include stdlib

	$suffix = "dc=vagrant,dc=dev"

	notify { "Welcome":
		message => hiera("welcome_message"),
	}

	notify { "Information":
		message => "Creating LDAP setup as ${suffix}",
	}

	class { "ldap::client":
  		uri  => "ldap://ldap.vagrant.dev",
  		base => "${suffix}",
	}

	class { "ldap::server":
		suffix  => "${suffix}",
		rootdn  => "cn=admin,${suffix}",
		rootpw  => "admin",
	}

	class { 'phpldapadmin':
		ldap_host      => 'localhost',
		ldap_suffix    => "${suffix}",
		ldap_bind_id   => "cn=admin,${suffix}",
		ldap_bind_pass => "admin",
		extraconf      => "
			\$servers->newServer('ldap_pla');
			\$servers->SetValue('server','name','LDAP for Dev');
			\$servers->SetValue('server','host','ldap.vagrant.dev');
			\$servers->SetValue('server','port','389');
			\$servers->SetValue('server','base',array('${suffix}','cn=config'));
			\$servers->SetValue('login','auth_type','session');
			\$servers->SetValue('login','bind_id','cn=admin,{suffix}');
			\$servers->SetValue('server','tls',false);
			\$servers->SetValue('appearance','password_hash_custom','crypt');
			\$servers->SetValue('server','read_only',false);
			\$servers->SetValue('appearance','show_create',true);
			\$servers->SetValue('auto_number','enable',false);"
	}
}

exec { "echo":
  command => "/usr/bin/apt-get update"
}

Exec["echo"] -> Package <| |>