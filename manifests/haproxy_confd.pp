# == Class: profiles::haproxy_confd
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
class profiles::haproxy_confd {
  include profiles::haproxy_confd::ppa
  include profiles::haproxy_confd::haproxy
  include profiles::haproxy_confd::confd
  include profiles::haproxy_confd::config

  Class['profiles::haproxy_confd::ppa']
  ~>
  Class['profiles::haproxy_confd::haproxy']
  ~>
  Class['profiles::haproxy_confd::confd']
  ~>
  Class['profiles::haproxy_confd::config']

}
