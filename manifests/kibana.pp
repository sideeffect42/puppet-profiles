class profiles::kibana {

  $version = hiera(kibana::version, '4.1.3-linux-x64')
  class { '::kibana4':
    package_ensure    => $version
  }

}
