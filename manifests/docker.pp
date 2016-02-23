class profiles::docker {

  include ::docker

  $config_dir = hiera('docker::config_dir', '/etc/docker')
  $auth_dir   = hiera('docker::auth_dir', undef)
  $auth_user  = hiera('docker::auth_user', undef)
  $auth_pass  = hiera('docker::auth_pass', undef)

  if hiera("${name}::folders", false) {
    file { hiera_array("${name}::folders"):
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0440',
    }
  }

  if $auth_dir {
    file { $auth_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }

    if $auth_user {
      file { "${auth_dir}/htpasswd":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => "${auth_user}:${auth_pass}\n",
      }
    }
  }

}
