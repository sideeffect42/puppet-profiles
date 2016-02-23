class profiles::graylog {

  class {'graylog2::repo':
    version => '1.3'
  } ->
  class {'graylog2::server':
    password_secret    => '8IFCKdCAVsjiz3twJVCrQCbjKUN1dvBAUzntLybTHiI7MuCICoi7QVNK66cljq9VplsY4A',
    root_password_sha2 => '4bbdd5a829dba09d7a7ff4c1367be7d36a017b4267d728d31bd264f63debeaa6'
  } ->
  class {'graylog2::web':
    application_secret => 'OpVZds1VjorNyVvdrKovriaPVRtyfNgnl9cGErjCzugHRlXsqHzfF7zalfdkP3GTjQBcTp',
  }
  package {'graylog-plugin-output-syslog':
    ensure => 'present',
  }

}
