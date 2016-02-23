class profiles::mongodb {

  class {'::mongodb::globals': }->
  class {'::mongodb::server': }->
  class {'::mongodb::client': }

}
