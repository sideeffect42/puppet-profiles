# == Class: profiles::haproxy_confd::haproxy
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
class profiles::haproxy_confd::haproxy {

  $haproxy_confd_template = "haproxy.tmpl"

  class { '::haproxy':
    config_file       => "/etc/confd/templates/$haproxy_confd_template",
    global_options   => {
      'log'     => "/dev/log local0",
      },
  }

  $haproxy_listen = hiera('haproxy::listen', undef)
    if $haproxy_listen {
      create_resources('haproxy::listen', $haproxy_listen)
  }

  $haproxy_confd = hiera('haproxy::balancermember', undef)
    if $haproxy_confd {
      create_resources('haproxy::balancermember', $haproxy_confd)
  }

  $haproxy_default = hiera('haproxy::default', undef)
    if $haproxy_default {
      create_resources('haproxy::default', $haproxy_default)
  }

  $haproxy_frontend = hiera_hash('haproxy::frontend', undef)
    if $haproxy_frontend {
      create_resources('haproxy::frontend', $haproxy_frontend)
  }

  $haproxy_backend = hiera_hash('haproxy::backend', undef)
    if $haproxy_backend {
      create_resources('haproxy::backend', $haproxy_backend)
  }

}
