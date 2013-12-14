class sabnzbd::service inherits sabnzbd {
  if $service_manage == true {
    supervisor::service { 'sabnzbd':
    command        => "${venv_dir}/bin/python ${src_dir}/SABnzbd.py -f ${config_dir}/sabnzbd.ini",
    ensure         => "${service_ensure}",
    enable         => "${service_enable}",
    stdout_logfile => "${log_dir}/supervisor.log",
    stderr_logfile => "${log_dir}/supervisor.log",
    user           => "${user}",
    group          => "${group}";
    }
  }
}