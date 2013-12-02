class sabnzbd {

    include sabnzbd::params
    include sabnzbd::config

    $package_deps = ['unrar','unzip','p7zip','par2','python-yenc']
    package { "${sabnzbd::package_deps}":
        ensure => 'installed'
    }

    user { 'sabnzbd':
        ensure    => 'present',
        allowdupe => false,
        uid       => '600',
        shell     => '/bin/bash',
        gid       => '700',
        home      => "${sabnzbd::params::base_dir}/sabnzbd",
        password  => '*',
    }

    file { "${sabnzbd::params::base_dir}/sabnzbd":
        ensure  => directory,
        owner   => 'sabnzbd',
        group   => 'sabnzbd',
        mode    => '0644',
        recurse => true
    }

		python::virtualenv { "${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}":
		    ensure       => present,
		    owner        => 'sabnzbd',
		    group        => 'sabnzbd',
        require      => [Package['python-yenc'],File["${sabnzbd::params::base_dir}/sabnzbd"]]
		  }

    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone ${sabnzbd::params::url} src",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/src",
        user    => 'sabnzbd',
        require => Class['git'],
    }
    exec { 'install-pyopenssl':
        command => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/pip install pyOpenSSL",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd/venv",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/venv/lib/python2.7/site-packages/OpenSSL",
        path    => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin",
        user    => 'sabnzbd',
        require => Python::Virtualenv['${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}'];
    }
    exec { 'install-cheetah-sabnzbd':
        command => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/pip install cheetah",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd/venv",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/cheetah",
        path    => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin",
        user    => 'sabnzbd',
        require => Python::Virtualenv['${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}'];
    }

    
    supervisor::service { 'sabnzbd':
        ensure         => present,
        stdout_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        stderr_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
        command        => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/python ${sabnzbd::params::base_dir}/sabnzbd/src/SABnzbd.py -f ${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini",
        user           => 'sabnzbd',
        group          => 'sabnzbd',
        directory      => "${sabnzbd::params::base_dir}/sabnzbd/src/",
        require        => Exec['download-sabnzbd'],
    }
}