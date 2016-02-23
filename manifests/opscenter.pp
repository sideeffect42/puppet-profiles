class profiles::opscenter {

  class { 'opscenter':
    repo   => true,
    auth   => 'True',
  }
  
}
