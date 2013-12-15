class sabnzbd::config inherits sabnzbd {
  # Ensure Directories Exist/Chown/Chmod  
  file { ["${log_dir}","${config_dir}"]:
    ensure => directory,
    owner  => "${user}",
    group  => "${group}",
    mode   => '0644';
  }
  
  file { "${config_dir}/sabnzbd.ini":
    content => template('sabnzbd/sabnzbd.ini.erb'),
    owner  => "${user}",
    group  => "${group}",
    mode    => '0644',
    require => File["${config_dir}"];
  }
}