# == Class: profiles::haproxy_confd::config
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
class profiles::haproxy_confd::config {

  exec { 'confd_run_update':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => '/usr/local/sbin/upconfd.sh --backend env',
    require     => [Package['python-novaclient'],File['/usr/local/etc/nova_ro_creds.rc'],File['/usr/local/sbin/upconfd.sh'],Class['::confd']],
    refreshonly => true,
  }

}
