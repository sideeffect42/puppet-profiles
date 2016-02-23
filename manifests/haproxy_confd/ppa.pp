# == Class: profiles::haproxy_confd::ppa
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
class profiles::haproxy_confd::ppa {
    include apt

    apt::ppa { 'ppa:vbernat/haproxy-1.5': }
    Class['apt::update'] -> Package<| |>
}
