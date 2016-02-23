class profiles::openldap {

  include ::ldap::server

  # put gem binary someplace in the $PATH
  file { '/usr/local/bin/gem':
    ensure => link,
    target => '/opt/puppetlabs/puppet/bin/gem',
  }

  # prerequisite for resource "ldap_entry"
  package { 'net-ldap':
    ensure   => present,
    provider => 'gem',
  }

  file {
    "${settings::ssldir}/private_keys":               group => 'openldap';
    "${settings::ssldir}/private_keys/${::fqdn}.pem": group => 'openldap';
  }

  $dn      = hiera('ldap::server::suffix')
  $admin   = hiera('ldap::server::rootdn')
  $adminpw = hiera('ldap::server::rootpw')

  $defaultPassword = sha1digest('password')

  $ldap_defaults = {
    ensure   => present,
    host     => 'localhost',
    port     => 389,
    ssl      => false,
    base     => $dn,
    username => $admin,
    password => $adminpw,
  }

  $ldap_entries = hiera_hash('ldap::entries')
  create_resources('ldap_entry', $ldap_entries, $ldap_defaults)

}
