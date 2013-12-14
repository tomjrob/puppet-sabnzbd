class sabnzbd::install inherits sabnzbd {
  # Create User
  user { "${user}":
    ensure    => 'present',
    allowdupe => false,
    shell     => '/bin/bash',
    home      => '"${base_dir}"/"${user}"',
    password  => "${user}";
  }
  
  # Install Package Dependencies
  exec { "apt_update":
  command => 'apt-get -y update',
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
  group   => "${group}",
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
  }
}