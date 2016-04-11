class profiles::puppetmaster {

  service { 'puppetserver':
    ensure => running,
    enable => true,
  }

  file { "${settings::confdir}/autosign.conf":
    ensure  => file,
    content => "*.$domain",
    notify  => Service['puppetserver'],
  }
  file { '/opt/puppetlabs/bin/r10k':
    ensure => 'link',
    target => '/opt/puppetlabs/puppet/bin/r10k'
  }
  file { '/etc/default/puppetserver':
    content => template("$module_name/puppetmaster/puppet_default.erb"),
    notify  => Service['puppetserver'],
  }

}
