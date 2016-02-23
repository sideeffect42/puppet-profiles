# == Class: profiles::haproxy_confd::confd
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
class profiles::haproxy_confd::confd (
  $backend_filter,
){
  include profiles::haproxy_confd::novaclient

  class { '::confd':
    sitemodule => 'confd',
    backend    => 'env',
    require    => Class['Profiles::Haproxy_confd::Novaclient'],
  }

  confd::resource { 'haproxy':
    dest       => '/etc/haproxy/haproxy.cfg',
    src        => $haproxy_confd_template,
    keys       => [ '/services/web' ],
    group      => 'root',
    owner      => 'root',
    mode       => '0644',
    reload_cmd => 'echo restarting && service haproxy reload',
    notify     => Exec['confd_run_update']
  }

  file { '/etc/confd/haproxy_backend_types':
    ensure  => present,
    path    => '/etc/confd/haproxy_backend_types',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => join($backend_filter, "\n"),
    notify     => Exec['confd_run_update']
  }

  file { '/usr/local/sbin/upconfd.sh':
    ensure  => present,
    path    => '/usr/local/sbin/upconfd.sh',
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/confd/upconfd.sh',
    notify  => Exec['confd_run_update'],
  }

 cron { upconfd:
    ensure  => present,
    command => "/usr/local/sbin/upconfd.sh --backend env",
    user    => root,
    minute  => '*/10',
    require => File['/usr/local/sbin/upconfd.sh'],
  }
}
