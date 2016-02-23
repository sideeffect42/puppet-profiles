class profiles::nexus {

  include ::java
  include ::nexus
  include ::apt_mirror

  Class['::java'] -> Class['::nexus']

  file { hiera('apt_mirror::base_path'):
    ensure => 'directory',
    owner  => 'nexus',
    group  => 'nexus',
    mode   => '0755',
  }

}
