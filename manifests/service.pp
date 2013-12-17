class sabnzbd::service inherits sabnzbd {
  if $service_manage == true {
    supervisor::service { 'sabnzbd':
    command        => "${venv_dir}/bin/python ${src_dir}/SABnzbd.py -f ${config_dir}/sabnzbd.ini",
    ensure         => present,
    enable         => true,
    stdout_logfile => "${log_dir}/supervisor.log",
    stderr_logfile => "${log_dir}/supervisor.log",
    user           => "${user}",
    group          => "${group}";
    }
  }
}