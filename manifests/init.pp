class sabnzbd (
  $base_dir,
  $url,
  $service_manage,
  $user,
  $group,
  $package_deps,
  $gem_deps,
  $port,
  $host,
  
  $misc = {},
  $servers = {},
  $categories = {},
) {
  
  validate_absolute_path($base_dir)
  validate_string($url)
  validate_bool($service_manage)
  validate_string($user)
  validate_string($group)
  
  $log_dir = "${base_dir}/log"
  $config_dir = "${base_dir}/config"
  
  $venv_dir = "${base_dir}/venv"
  $src_dir = "${base_dir}/src"
  
  anchor { 'sabnzbd::begin': } ->
  class { '::sabnzbd::install': } ->
  class { '::sabnzbd::config': } ~>
  class { '::sabnzbd::service': } ->
  anchor { 'sabnzbd::end': }
  }