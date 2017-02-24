class profiles::ldap_account_manager {
  ensure_packages({
    'ldap-account-manager' => {
      ensure => present,
    },
  })
}
