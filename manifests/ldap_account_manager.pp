class profiles::ldap_account_manager(
  $vhost_domain = undef,
) {
  # configure Apache httpd web server
  class { '::apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }
  include ::apache::mod::php
  include ::apache::mod::rewrite

  apache::vhost { 'ldap-account-manager':
    port       => 80,
    docroot    => '/usr/share/ldap-account-manager',
    servername => "$vhost_domain",
  }
  apache::vhost { 'ssl-ldap-account-manager':
    ssl        => true,
    port       => 443,
    docroot    => '/usr/share/ldap-account-manager',
    servername => "$vhost_domain",
  }

  $php_prefix = 'php' # TODO: set correctly based on system version
  ensure_packages({
    'ldap-account-manager' => {
      ensure => present,
      notify => Service['apache2'],
    },
    "$php_prefix-xml" => {
      ensure => present,
      notify => Service['apache2'],
    },
    "$php_prefix-zip" => {
       ensure => present,
       notify => Service['apache2'],
    }
  })

  file { '/etc/apache2/conf.d/ldap-account-manager':
    ensure => link,
    target => '/etc/ldap-account-manager/apache.conf',
  }
}
