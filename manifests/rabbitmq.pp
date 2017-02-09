class profiles::rabbitmq {

  include ::rabbitmq

  file { ["${settings::ssldir}/private_keys", "${settings::ssldir}/private_keys/${::fqdn}.pem"]:
    group => 'rabbitmq',
  }
}
