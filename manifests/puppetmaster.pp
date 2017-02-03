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

  $puppet_confdir = '/etc/puppetlabs/puppet'
  $puppet_ssldir = "$puppet_confdir/ssl"
  $foreman_url = 'http://localhost/'

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
  } else {
    file { "$puppet_confdir/foreman.yaml":
      ensure => absent,
    }
    file { "$puppet_confdir/node.rb":
      ensure => absent,
    }
  }
}
