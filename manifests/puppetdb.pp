class profiles::puppetdb {

  include ::puppetdb::database::postgresql
  include ::puppetdb::server
  include ::puppetdb::master::config

}
