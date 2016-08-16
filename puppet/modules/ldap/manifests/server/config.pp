# == Class: ldap::server::config
#
# Manage the configuration of the ldap server service
#
class ldap::server::config inherits ldap::server {
  # If $config is true, we will be configuring the "config" LDAP database
  # for storing OpenLDAP configurations in LDAP itself.
  if $config {
    # If $configdn is set, use that in the template.  Else use $rootdn
    if $configdn {
      $_configdn = $configdn
    } else {
      $_configdn = $::ldap::server::rootdn
    }
    # If $configpw is set, use that in the template.  Else use $rootpw
    if $configpw {
      $_configpw = $configpw
    } else {
      $_configpw = $::ldap::server::rootpw
    }
  }

  # If $monitor is true, we will be configuring the "monitor" LDAP database
  # which allows us to query the LDAP server for statistics about itself
  if $monitor {
    # If $monitordn is set, use that in the template.  Else use $rootdn
    if $monitordn {
      $_monitordn = $monitordn
    } else {
      $_monitordn = $::ldap::server::rootdn
    }
    # If $monitorpw is set, use that in the template.  Else use $rootpw
    if $monitorpw {
      $_monitorpw = $monitorpw
    } else {
      $_monitorpw = $::ldap::server::rootpw
    }
  }

  file { $ldap::server::config_file:
    owner   => $ldap::server::ldapowner,
    group   => $ldap::server::ldapgroup,
    # may contain passwords
    mode    => $ldap::server::config_file_mode,
    content => template($ldap::server::config_template),
  }

  if $ldap::server::default_file {
    file { $ldap::server::default_file:
      owner   => 0,
      group   => 0,
      mode    => $ldap::server::default_file_mode,
      content => template($ldap::server::default_template),
    }
  }

  file { $ldap::server::schema_directory:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => $ldap::server::schema_directory_mode,
  }
  ->
  ldap::schema_file { $ldap::server::extra_schemas:
    directory        => $ldap::server::schema_directory,
    source_directory => $ldap::server::schema_source_directory,
  }

  file { $ldap::server::directory:
    ensure => directory,
    owner  => $ldap::server::ldapowner,
    group  => $ldap::server::ldapgroup,
    mode   => $ldap::server::directory_mode,
  }

  file { $ldap::server::run_directory:
    ensure => directory,
    owner  => $ldap::server::ldapowner,
    group  => $ldap::server::ldapgroup,
    mode   => $ldap::server::run_directory_mode,
  }

  if $ldap::server::backend == 'bdb' or $ldap::server::backend == 'hdb' {
    file { $ldap::server::db_config_file:
      owner   => $ldap::server::ldapowner,
      group   => $ldap::server::ldapgroup,
      mode    => $ldap::server::db_config_file_mode,
      content => template($ldap::server::db_config_template),
      require => File[$ldap::server::directory],
    }
  }

  if $ldap::server::dynconfig_directory and $ldap::server::purge_dynconfig_directory == true {
    file { $ldap::server::dynconfig_directory:
      ensure  => absent,
      path    => $ldap::server::dynconfig_directory,
      recurse => true,
      purge   => true,
      force   => true,
    }
  }
}
