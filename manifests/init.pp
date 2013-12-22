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
  $pause_on_post_processing,
  $download_dir,
  $complete_dir,
  $script_dir,
  $api_key,
  $servers,
  $categories,
  $test = '""',
) {
  
  validate_absolute_path($base_dir)
  validate_string($url)
  validate_bool($service_manage)
  validate_string($user)
  validate_string($group)
  
  $venv_dir = "${base_dir}/venv"
  $log_dir = "${base_dir}/log"
  $config_dir = "${base_dir}/config"
  $src_dir = "${base_dir}/src"
  
  anchor { 'sabnzbd::begin': } ->
  class { '::sabnzbd::install': } ->
  class { '::sabnzbd::config': } ~>
  class { '::sabnzbd::service': } ->
  anchor { 'sabnzbd::end': }
  }