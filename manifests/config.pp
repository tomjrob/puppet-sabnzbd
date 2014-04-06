class sabnzbd::config inherits sabnzbd {
  file { "${config_dir}/sickbeard.ini":
    content => template('sabnzbd/sabnzbd.ini.erb'),
    owner  => "${user}",
    group  => "${group}",
    mode    => '0644';
  }
}