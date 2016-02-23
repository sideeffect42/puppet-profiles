class profiles::gitlab {

  include ::gitlab

  file {
    "${settings::ssldir}/private_keys":               group => 'gitlab-www';
    "${settings::ssldir}/private_keys/${::fqdn}.pem": group => 'gitlab-www';
  }

}
