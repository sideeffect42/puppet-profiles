class profiles::rsyslog {

  include ::rsyslog::server

  $rsyslog_logdir = hiera('rsyslog::log_dir', undef)
  if $rsyslog_logdir {
    file { $rsyslog_logdir:
      ensure => directory,
      owner  => hiera('rsyslog::log_user', 'root'),
      group  => hiera('rsyslog::log_group', 'root'),
      mode   => '2750',
    }
  }

  $rsyslogd_fragments = hiera_hash('rsyslog::rsyslogd', undef)
  if $rsyslogd_fragments {
    create_resources('rsyslog::snippet', $rsyslogd_fragments)
  }

}
