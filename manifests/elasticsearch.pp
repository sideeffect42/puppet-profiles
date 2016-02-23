class profiles::elasticsearch {

  include ::java
  include ::elasticsearch

  apt::key { 'elasticsearch':
    id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
    source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
  }

  $plugins = hiera('elasticsearch::plugin', undef)
  if $plugins {
    create_resources('elasticsearch::plugin', $plugins)
  }

}
