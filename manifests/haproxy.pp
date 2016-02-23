class profiles::haproxy {

  include ::haproxy

  if ! hiera('profiles::haproxy::workaround', false) {
    $lb_name = hiera($hostname, undef)
    $lb_addr = inline_template("<% _erbout.concat(Resolv::DNS.open.getaddress('$lb_name').to_s) %>")

    haproxy::frontend { hiera('haproxy_frontend_name'):
      ipaddress => $::ipaddress_eth1,
      ports     => hiera_array('haproxy_frontend_ports'),
      mode      => 'http',
    }

    haproxy::backend { hiera_array('haproxy_backend_names'):
      options => {
        'option'  => [
          'forwardfor',
        ],
        'balance' => hiera('haproxy_balance_method', 'roundrobin'),
      }
    }

    $proxy_members = hiera_hash('haproxy::balancermembers')
    create_resources('haproxy::balancermember', $proxy_members)

  } else {

    $ha_default = hiera('haproxy::default', undef)
    if $ha_default {
      create_resources('haproxy::default', $ha_default)
    } 
  
    $ha_frontend = hiera_hash('haproxy::frontend', undef)
    if $ha_frontend {
      create_resources('haproxy::frontend', $ha_frontend)
    } 
  
    $ha_backend = hiera_hash('haproxy::backend', undef)
    if $ha_backend {
      create_resources('haproxy::backend', $ha_backend)
    }

  }

}
