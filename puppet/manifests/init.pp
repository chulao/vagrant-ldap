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
}

exec { "echo":
  command => "/usr/bin/apt-get update"
}

Exec["echo"] -> Package <| |>