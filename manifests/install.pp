class sabnzbd::install inherits sabnzbd {
  # Create User
  user { "${user}":
    ensure    => 'present',
    allowdupe => false,
    shell     => '/bin/bash',
    system    => true;
    }
  
  # Ensure Directories Exist/Chown/Chmod  
  file { ["${base_dir}","${log_dir}","${config_dir}"]:
    ensure => directory,
    owner  => "${user}",
    group  => "${group}",
    mode   => '0644';
  }
  
  # Install Package Dependencies
  exec { "apt_update":
  command => '/usr/bin/apt-get -y update',
  } ->
  package { $package_deps:
  ensure => 'installed',
  }
  
  # Install Python, Set up Virtual Enironment, Install PIP Dependencies
  class { 'python':
  pip  => true,
  virtualenv => true,
  dev => true,
  } ->
  python::virtualenv { "${venv_dir}":
  ensure  => present,
  owner   => "${user}",
  group   => "${group}";
  } ->
  python::pip { $pip_deps:
  ensure     => present,
  virtualenv => "${venv_dir}",
  owner      => "${user}";  
  }
  
  # Get latest Sabnzbd from git source
  vcsrepo { "${src_dir}":
  ensure   => latest,
  provider => git,
  source   => "${url}",
  revision => master,
  user     => "${user}",
  group    => "${group}",
  require => File["${base_dir}"];
  }
}