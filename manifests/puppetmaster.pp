class profiles::puppetmaster (
  $autosign_domain = true,
  $foreman_integration = false,
  $foreman_url = 'http://localhost/' # only needed when using Foreman integration
) {

  service { 'puppetserver':
    ensure => running,
    enable => true,
  }

  # certificate autosigning
  file_line { 'autosign.conf':
    ensure  => $autosign_domain ? { true => present, default => absent },
    path    => "${settings::confdir}/autosign.conf",
    line    => "*.$domain",
    notify  => Service['puppetserver'],
  }

  # symlink r10k into PATH
  file { '/opt/puppetlabs/bin/r10k':
    ensure => 'link',
    target => '/opt/puppetlabs/puppet/bin/r10k'
  }

  file { '/etc/default/puppetserver':
    content => template("$module_name/puppetmaster/puppet_default.erb"),
    notify  => Service['puppetserver'],
  }

  # disable puppet analytic data collection
  file { '/etc/puppetlabs/puppetserver/conf.d/product.conf':
    content => template("$module_name/puppetmaster/puppetserver_product_conf.erb"),
    notify => Service['puppetserver'],
  }


  # Foreman integration
  $puppet_confdir = '/etc/puppetlabs/puppet'
  $puppet_ssldir = "$puppet_confdir/ssl"

  if $foreman_integration {
    file { "$puppet_confdir/foreman.yaml":
      ensure  => file,
      content => template("$module_name/puppetmaster/foreman.yaml.erb"),
    }

    file { "$puppet_confdir/node.rb":
      ensure  => file,
      source  => "puppet:///modules/$module_name/puppetmaster/node.rb",
      mode    => '+x',
      notify  => Service['puppetserver'],
    }

    file { "$puppet_confdir/yaml":
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
    }
    file { "$puppet_confdir/yaml/foreman":
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
    }
  } else {
    file { "$puppet_confdir/foreman.yaml":
      ensure => absent,
    }
    file { "$puppet_confdir/node.rb":
      ensure => absent,
    }
  }
}
