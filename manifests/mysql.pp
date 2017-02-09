class profiles::mysql (
  $gpg_recipient = undef,
) {
  $mysql_group = hiera('mysql::server::mysql_group', 'mysql')
  $root_pass   = hiera('mysql::root_pass', undef)
  $databases   = hiera_hash('mysql::db', undef)
  $recipient   = $gpg_recipient

  $common_options = deep_merge(hiera_hash('mysql::options', undef), hiera_hash('mariadb::server::override_options', undef))
  $master_options = {
    'mysqld' => {
      innodb_flush_log_at_trx_commit => '1',
      sync_binlog                    => '1',
    }
  }
  $slave_options = {
    'mysqld' => {
      'relay-log'         => 'mysql-relay-bin',
      'log-slave-updates' => '1',
      'read-only'         => '1',
    }
  }

  $db_master_query    = hiera('mysql::master_query', "_role='database' and _serverid='1'")
  $replication_master = query_nodes($db_master_query, fqdn)[0]
  $replication_user   = hiera('replication_user', undef)
  $replication_pass   = hiera('replication_pass', undef)

  if $::fqdn == $replication_master {
    $options = deep_merge($common_options, $master_options)

    mysql_user { "${replication_user}@%":
      ensure        => 'present',
      password_hash => mysql_password($replication_pass)
    } ->
    mysql_grant { "${replication_user}@%/*.*":
      ensure     => 'present',
      privileges => ['REPLICATION SLAVE'],
      table      => '*.*',
      user       => "${replication_user}@%",
    }
  } else {
    $options = deep_merge($common_options, $slave_options)
  }

  if $options['mysqld']['ssl'] {
    file {
      "${settings::ssldir}/private_keys":
        group => $mysql_group;
      "${settings::ssldir}/private_keys/${::fqdn}.pem":
        group => $mysql_group;
    }
  }

  if $databases {
    $db_pass = hiera('database_pass', undef)
    $default_db_params = {
      user     => hiera('database_user', 'mysql'),
      password => $db_pass,
    }
    create_resources('mysql::db', $databases, $default_db_params)

    # add user@% grants
    $default_user_params = {
      ensure        => 'present',
      password_hash => mysql_password($db_pass),
      provider      => 'mysql',
    }
    unique(values($databases)).each |$item| {
      ensure_resource('mysql_user', "${item['user']}@%", $default_user_params)
      mysql_grant { "${item['user']}@%/*.*":
        user       => "${item['user']}@%",
        privileges => 'ALL',
        table      => '*.*',
        provider   => 'mysql',
        require    => [
          Mysql_user["${item['user']}@%"],
        ],
      }
    }
  }

  file { '/usr/local/bin/prebackup':
    mode    => '0555',
    content => template("$module_name/mysql/mysql_prebackup.erb"),
  }

}
