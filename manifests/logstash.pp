class profiles::logstash {

  include ::java
  include ::logstash

  apt::key { 'elasticsearch':
    id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
    source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
  }

  Class['::java'] -> Class['::logstash']

  $configfile = hiera('logstash::configfile', '/etc/logstash/conf.d/logstash.conf')
  $config_content = hiera('logstash::config_content')
  
  if $config_content {
    logstash::configfile { $configfile:
      content => $config_content
    }
  }

}
