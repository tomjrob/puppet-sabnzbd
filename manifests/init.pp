class sabnzbd {
    include sabnzbd::params
    include sabnzbd::config
    
    class { 'python':
      pip  => true,
      virtualenv => true,
      dev => true,
      
      }
      
    $package_deps = ['unrar','unzip','p7zip','par2','python-yenc']
    $pip_deps = ['pyOpenSSL','cheetah']
    
    $venv = "${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}"
    
    package { $package_deps:
        ensure => 'installed';
        
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
        recurse => true
        
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
        
#            python::pip {'pyOpenSSL':
#        ensure => present,
#        virtualenv => "${venv}",
#        owner => 'sabnzbd',
#        
#        }
    
#    python::pip {'cheetah':
#        ensure => present,
#        virtualenv => "${venv}",
#        owner => 'sabnzbd',
#        
#        }
    
   vcsrepo { "${sabnzbd::params::base_dir}/sabnzbd/src":
        ensure => latest,
        provider => git,
        source => "${sabnzbd::params::url}",
        revision => master,
        user => 'sabnzbd',
        require => File["${sabnzbd::params::base_dir}/sabnzbd"],
        
        }
  
    supervisor::service { 'sabnzbd':
        ensure         => present,
        enable         => true,
        stdout_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        stderr_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        command        => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/python ${sabnzbd::params::base_dir}/sabnzbd/src/SABnzbd.py -f ${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini",
        user           => 'sabnzbd',
        group          => 'sabnzbd',
        directory      => "${sabnzbd::params::base_dir}/sabnzbd/src/",
        require        => [Vcsrepo["${sabnzbd::params::base_dir}/sabnzbd/src"],Python::Virtualenv["${venv}"]];
        
        }
        
        }