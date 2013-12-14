class sabnzbd (
  $base_dir = $sabnzbd::params::base_dir,
  $url = $sabnzbd::params::url,
  $service_manage = $sabnzbd::params::service_manage,
  $service_enable = $sabnzbd::params::service_enable,
  $service_ensure = $sabnzbd::params::service_ensure,
  $user = $sabnzbd::params::user,
  $group = $sabnzbd::params::group,
) inherits sabnzbd::params {

  validate_absolute_path($base_dir)
  validate_string($url)
  validate_bool($service_manage)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_string($user)
  validate_string($group)
  
  anchor { 'sabnzbd::begin': } ->
  class { '::sabnzbd::install': } ->
  class { '::sabnzbd::config': } ~>
  class { '::sabnzbd::service': } ->
  anchor { 'sabnzbd::end': }
}