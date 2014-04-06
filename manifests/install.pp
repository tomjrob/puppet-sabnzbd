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
  
  # Set up Virtual Enironment, Install PIP Dependencies
  file { "${base_dir}/requirements.txt":
    ensure => present,
    owner  => "${user}",
    group  => "${group}",
    mode   => '0644',
    content => inline_template('<% @gem_deps.each do |dep| -%><%= dep %>
<% end -%>');
  } ->
  python::virtualenv { "${venv_dir}":
  ensure  => present,
  owner   => "${user}",
  group   => "${group}",
  requirements => "${base_dir}/requirements.txt";
  }
  
  # Get latest sabnzbd from git source
  vcsrepo { "${src_dir}":
  ensure   => present,
  provider => git,
  source   => "${url}",
  revision => master,
  user     => "${user}",
  group    => "${group}",
  require => File["${base_dir}"];
  }
}