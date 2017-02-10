class profiles::base (
  $root_password = true
) {

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

  if $root_password == false {
    exec { 'delete_root_password':
      command   => '/usr/bin/passwd -d root',
      unless    => '/usr/bin/test "x" = "x$(/bin/grep "^root" /etc/shadow | /usr/bin/cut -d: -f2)"',
      logoutput => true,
    }
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

  $install_packages = hiera_array("${name}::packages", undef)
  if $install_packages {
    ensure_packages($install_packages)
  }
  $remove_packages = hiera_array("${name}::packages_remove", undef)
  if $remove_packages {
    ensure_packages($remove_packages, {ensure => absent,})
  }

  $ssh_keygen = hiera_hash('ssh_keygen', undef)
  if $ssh_keygen {
    create_resources('ssh_keygen', $ssh_keygen)
  }

}
