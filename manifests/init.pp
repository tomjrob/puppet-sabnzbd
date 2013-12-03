class sabnzbd {

    include sabnzbd::params
    include sabnzbd::config
    include git
    
    class { 'python':
      pip  => true,
      virtualenv => true,
      dev => true,
      }
      
    $package_deps = ['unrar','unzip','p7zip','par2','python-yenc']
    $venv = "${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}"
    package { $package_deps:
        ensure => 'installed'
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
        require      => File["${sabnzbd::params::base_dir}/sabnzbd"]
		  }
    
    python::pip {'pyOpenSSL':
        ensure => present,
        virtualenv => "${venv}",
        owner => 'sabnzbd',
    }
    
    python::pip {'cheetah':
        ensure => present,
        virtualenv => "${venv}",
        owner => 'sabnzbd',
    }
    
    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone ${sabnzbd::params::url} src",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/src",
        user    => 'sabnzbd',
        require => Class['git'],
    }
    

#    exec { 'install-pyopenssl':
#        command => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/pip install pyOpenSSL",
#        cwd     => "${sabnzbd::params::base_dir}/sabnzbd/venv",
#        creates => "${sabnzbd::params::base_dir}/sabnzbd/venv/lib/python2.7/site-packages/OpenSSL",
#        path    => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin",
#        user    => 'sabnzbd',
#        require => [Python::Virtualenv["${venv}"],Class['python']];
#    }
#    exec { 'install-cheetah-sabnzbd':
#        command => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/pip install cheetah",
#        cwd     => "${sabnzbd::params::base_dir}/sabnzbd/venv",
#        creates => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/cheetah",
#        path    => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin",
#        user    => 'sabnzbd',
#        require => [Python::Virtualenv["${venv}"],Class['python']];
#    }
    
    supervisor::service { 'sabnzbd':
        ensure         => present,
        enable         => true,
        stdout_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        stderr_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        command        => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/python ${sabnzbd::params::base_dir}/sabnzbd/src/SABnzbd.py -f ${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini",
        user           => 'sabnzbd',
        group          => 'sabnzbd',
        directory      => "${sabnzbd::params::base_dir}/sabnzbd/src/",
        require        => [Exec['download-sabnzbd'],Class['python']];
    }
}