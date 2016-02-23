class profiles::base {

  include stdlib
  include ntp
  include ssh
  include hosts
  include resolvconf
  include base
  include bash
  include bash::completion
  include vim
  include motd
  include lvm
  include sudo

  case $::osfamily {
    'Debian': {
      include apt

      $sources = hiera_hash('apt::repos', undef)
      if $sources {
        create_resources('apt::source', $sources)
      }
    }
  }

  class { 'accounts':
    groups     => hiera_hash('accounts::groups', {}),
    users      => hiera_hash('accounts::users', {}),
    accounts   => hiera_hash('accounts::accounts', {}),
    usergroups => hiera_hash('accounts::usergroups', {}),
    ssh_keys   => hiera_hash('accounts::ssh_keys', {}),
  }

  $sudoers = hiera_hash('sudo::conf', undef)
  if $sudoers {
    create_resources('sudo::conf', $sudoers)
  }

##############################################
  # in puppet server module auslagern 
##############################################
  file { "${settings::confdir}/puppet.conf":
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template("$module_name/base/puppet.conf.erb"),
  }
  file { "${settings::codedir}/hiera.yaml":
    mode    => '0644',
    content => template("$module_name/base/hiera.yaml.erb"),
  }
  service { 'puppet':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
##############################################
##############################################

  ensure_packages(hiera_array("${name}::packages"))

  $ssh_keygen = hiera_hash('ssh_keygen', undef)
  if $ssh_keygen {
    create_resources('ssh_keygen', $ssh_keygen)
  }

}
