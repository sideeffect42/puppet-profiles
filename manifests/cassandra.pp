class profiles::cassandra {

  class { ::cassandra:
    repo_key_id => '7E41C00F85BFC1706C4FFFB3350200F2B999A372'
  }

  file { '/etc/cassandra/cassandra-rackdc.properties':
    owner   => 'cassandra',
    group   => 'cassandra',
    mode    => '0644',
    content => template("$module_name/cassandra/cassandra-rackdc.properties.erb"),
  }

  $datastax_agent_stomp_interface = hiera(cassandra::datastax_agent_stomp_interface, '0.0.0.0')
  $datastax_agent_use_ssl = hiera(cassandra::datastax_agent_use_ssl, '0')

  $dse = hiera(cassandra::using_dse, false)

  if $dse == false {
    file { "/var/lib/datastax-agent/conf/address.yaml":
        ensure  => file,
        content => template("$module_name/cassandra/address.yaml.erb"),
        notify  => Service['datastax-agent'],
    }

    package { 'datastax-agent':
      ensure => 'present'
    }
  }

  $repair_cron = hiera(cassandra::repair_cron, true)
  
  if $repair_cron {
    cron { 'cassandara-repair':
      command => 'sleep $(ruby -e "puts rand(180)"); /usr/bin/nodetool repair -pr',
      user    => root,
      weekday => 0,
      hour    => $_index,
      minute  => 0,
    }
  }

}
