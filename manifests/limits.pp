class profiles::limits {

  include ::limits
 
  $limits = hiera('limits::fragment', {})
  create_resources('limits::fragment', $limits)

}
