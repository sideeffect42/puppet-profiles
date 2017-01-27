class profiles::accounts {
  class { 'accounts':
    groups         => hiera_hash('accounts::groups', {}),
    users          => hiera_hash('accounts::users', {}),
    accounts       => hiera_hash('accounts::accounts', {}),
    usergroups     => hiera_hash('accounts::usergroups', {}),
    ssh_keys       => hiera_hash('accounts::ssh_keys', {}),
    purge_ssh_keys => true,
  }
}
