class profiles::ldap_account_manager(
  $vhost_domain = undef,
  $http = true,
  $https = false,
  $hsts = true,
) {
  # configure Apache httpd web server
  class { '::apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }
  include ::apache::mod::php
  include ::apache::mod::rewrite

  if $http {
    apache::vhost { 'ldap-account-manager':
      port       => 80,
      docroot    => '/usr/share/ldap-account-manager',
      servername => "$vhost_domain",
    }
  }
  elsif $https {
    apache::vhost { 'ldap-account-manager':
      port            => 80,
      redirect_status => 'permanent',
      redirect_dest   => $vhost_domain ? {
        undef   => "https://$::fqdn/",
        default => "https://$vhost_domain/"
      },
    }
  }
  if $https {
    apache::vhost { 'ssl-ldap-account-manager':
      ssl        => true,
      port       => 443,
      docroot    => '/usr/share/ldap-account-manager',
      servername => "$vhost_domain",
      headers    => [
        $hsts ? { true => 'set Strict-Transport-Security: max-age=31536000', default => undef }
      ],
    }
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
