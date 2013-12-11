class sabnzbd {
    include sabnzbd::params
    include sabnzbd::config
      
    $package_deps = ['git','unrar','unzip','p7zip','par2','python-yenc', 'libssl-dev']
    $pip_deps = ['pyOpenSSL','cheetah']
    $venv = "${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}"

    class { 'python':
      pip  => true,
      virtualenv => true,
      dev => true,
      
      }
    
    exec { "apt_update":
      command => 'apt-get -y update'
    }
    
    package { $package_deps:
        ensure => 'installed',
        require => Exec['apt_update'],
        
        }

    user { 'sabnzbd':
        ensure    => 'present',
        allowdupe => false,
        shell     => '/bin/bash',
        home      => "${sabnzbd::params::base_dir}/sabnzbd",
        password  => 'sabnzbd';
        
        }

    file { "${sabnzbd::params::base_dir}/sabnzbd":
        ensure  => directory,
        owner   => 'sabnzbd',
        group   => 'sabnzbd',
        mode    => '0644',
        
        }
    
    python::virtualenv { "${venv}":
        ensure       => present,
        owner        => 'sabnzbd',
        group        => 'sabnzbd',
        require      => File["${sabnzbd::params::base_dir}/sabnzbd"],
        
        }
    
    python::pip { $pip_deps:
        ensure => present,
        virtualenv => "${venv}",
        owner => 'sabnzbd',
        
        }
        
   vcsrepo { "${sabnzbd::params::base_dir}/sabnzbd/src":
        ensure => latest,
        provider => git,
        source => "${sabnzbd::params::url}",
        revision => master,
        user => 'sabnzbd',
        require => File["${sabnzbd::params::base_dir}/sabnzbd"],
        
        }
  
    supervisor::service { 'sabnzbd':
      command        => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/python ${sabnzbd::params::base_dir}/sabnzbd/src/SABnzbd.py -f ${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini",
      ensure         => present,
      enable         => true,
      
      stdout_logfile => "${sabnzbd::params::log_dir}/supervisor.log",
      stderr_logfile => "${sabnzbd::params::log_dir}/supervisor.log",
      
      user           => 'sabnzbd',
      group          => 'sabnzbd',
      
      require        => [Vcsrepo["${sabnzbd::params::base_dir}/sabnzbd/src"],
        Python::Virtualenv["${venv}"],
        File["${sabnzbd::params::log_dir}"]
      ]
        
        }
        
        }