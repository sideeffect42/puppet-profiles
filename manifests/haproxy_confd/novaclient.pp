# == Class: profiles::haproxy_confd::novaclient
#
#
# === Parameters
#
#
# === Variables
#
# [*fqdn*]
#   Creates the *um directory structure for $fqdn
#
# === Examples
#
#
# === Authors
#
# Daniel Behm
#
# === Copyright
#
#
class profiles::haproxy_confd::novaclient {

  package { 'python-novaclient':
    ensure  => 'latest',
    before  => Class['::confd'],
  }

  file { '/usr/local/etc/nova_ro_creds.rc':
    ensure  => present,
    path    => '/usr/local/etc/nova_ro_creds.rc',
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/confd/nova_ro_creds.rc',
  }

}
