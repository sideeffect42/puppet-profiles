class profiles::puppetmaster (
  $autosign_domain = true,
  $foreman_integration = false
) {

  service { 'puppetserver':
    ensure => running,
    enable => true,
  }

  file_line { 'autosign.conf':
    ensure  => $autosign_domain ? { true => present, default => absent },
    path    => "${settings::confdir}/autosign.conf",
    line    => "*.$domain",
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
  file { '/etc/puppetlabs/puppetserver/conf.d/product.conf':
    content => template("$module_name/puppetmaster/puppetserver_product_conf.erb"),
    notify => Service['puppetserver'],
  }

  if $foreman_integration {
    file { '/etc/puppetlabs/puppet/foreman.yaml':
      ensure  => file,
      content => template("$module_name/puppetmaster/foreman.yaml.erb"),
    }

    file { '/etc/puppetlabs/puppet/node.rb':
      ensure  => file,
      source  => "puppet:///modules/$module_name/puppetmaster/node.rb",
      mode    => '+x',
      notify  => Service['puppetserver'],
    }
  } else {
    file { '/etc/puppetlabs/puppet/foreman.yaml':
      ensure => absent,
    }
    file { '/etc/puppetlabs/puppet/node.rb':
      ensure => absent,
    }
  }
}
