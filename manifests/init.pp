#
#
#
class sabnzbd {

    include sabnzbd::params
    include sabnzbd::config
    include sabnzbd::proxy
    include git
    include python::virtualenv
    include supervisor

    $package_deps = ['unrar','unzip','p7zip','par2','python-yenc']
    package { $sabnzbd::package_deps: ensure => 'installed' }

    user { 'sabnzbd':
        ensure    => 'present',
        allowdupe => false,
        uid       => '600',
        shell     => '/bin/bash',
        gid       => '700',
        home      => "${sabnzbd::params::base_dir}/sabnzbd",
        password  => '*',
    }

    file { '$sabnzbd::params::base_dir/sabnzbd':
        ensure  => directory,
        owner   => 'sabnzbd',
        group   => 'sabnzbd',
        mode    => '0644',
        recurse => true
    }

    exec { 'venv-create-sabnzbd':
        command => "virtualenv ${sabnzbd::params::venv_dir}",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/${sabnzbd::params::venv_dir}/bin/activate",
        path    => '/usr/bin/',
        user    => 'sabnzbd',
        require => [Class['python::virtualenv'], Package['python-yenc']];
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
        require => Exec['venv-create-sabnzbd'];
    }
    exec { 'install-cheetah-sabnzbd':
        command => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/pip install cheetah",
        cwd     => "${sabnzbd::params::base_dir}/sabnzbd/venv",
        creates => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/cheetah",
        path    => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin",
        user    => 'sabnzbd',
        require => Exec['venv-create-sabnzbd'];
    }

    if defined(Class['supervisor::service']) {
        supervisor::service {
            'sabnzbd':
                ensure         => present,
                enable         => true,
                stdout_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
                stderr_logfile => "${sabnzbd::params::base_dir}/sabnzbd/log/supervisor.log",
                command        => "${sabnzbd::params::base_dir}/sabnzbd/venv/bin/python ${sabnzbd::params::base_dir}/sabnzbd/src/SABnzbd.py -f ${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini",
                user           => 'sabnzbd',
                group          => 'sabnzbd',
                directory      => "${sabnzbd::params::base_dir}/sabnzbd/src/",
                require        => Exec['download-sabnzbd'],
        }
    }
}