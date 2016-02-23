class profiles::nginx {

  include ::nginx

  $htaccess = hiera_hash('profiles::nginx::htaccess', undef)
  $htaccess_defaults = {
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }
  if $htaccess {
    create_resources(file, $htaccess, $htaccess_defaults)
  }

}
