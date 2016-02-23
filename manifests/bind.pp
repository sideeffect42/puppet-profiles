class profiles::bind {

  include ::bind

  $zone = hiera_hash('bind::zone', undef)
  if $zone {
    create_resources('bind::zone', $zone)
  }
  $key = hiera_hash('bind::key', undef)
  if $key {
    create_resources('bind::key', $key)
  }
  $acl = hiera_hash('bind::acl', undef)
  if $acl {
    create_resources('bind::acl', $acl)
  }
  $view = hiera_hash('bind::view', undef)
  if $view {
    create_resources('bind::view', $view)
  }
  $resource_record = hiera_hash('bind::resource_record', undef)
  if $resource_record {
    create_resources('bind::resource_record', $resource_record)
  }


}
