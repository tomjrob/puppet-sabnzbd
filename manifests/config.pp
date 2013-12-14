#
#
#
class sabnzbd::config inherits sabnzbd {
  # Ensure Directories Exist/Chown/Chmod  
  file { ["${log_dir}","${config_dir}"]:
    ensure => directory,
    owner  => 'sabnzbd',
    group  => 'sabnzbd',
    mode   => '0644',
  }
  
  file { "${base_dir}/sabnzbd/config/sabnzbd.ini":
    content => template('sabnzbd/sabnzbd.ini.erb'),
    owner   => 'sabnzbd',
    group   => 'sabnzbd',
    mode    => '0644',
    require => File["${base_dir}/sabnzbd/config/"];
  }
}