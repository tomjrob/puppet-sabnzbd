#
#
#
class sabnzbd::config {
    include sabnzbd::params

    if defined(Class['logrotate::base']) and $sabnzbd::params::logrotate {
        logrotate::rule { 'sabnzbd':
            path          => "${sabnzbd::params::log_dir}/*",
            rotate        => 5,
            size          => '100k',
            sharedscripts => true,
            postrotate    => '/usr/bin/supervisorctl restart sabnzbd',
        }
    }

    file { "${sabnzbd::params::base_dir}/sabnzbd/config/":
        ensure => directory,
        owner  => 'sabnzbd',
        group  => 'sabnzbd',
    }

    file { "${sabnzbd::params::base_dir}/sabnzbd/config/sabnzbd.ini":
        content => template('sabnzbd/sabnzbd.ini.erb'),
        owner   => 'sabnzbd',
        group   => 'sabnzbd',
        mode    => '0644',
        require => File["${sabnzbd::params::base_dir}/sabnzbd/config/"],
        notify  => Supervisor::Service['sabnzbd'],
    }

    file { "${sabnzbd::params::cache_dir}/":
        ensure => directory,
        owner  => 'sabnzbd',
        group  => 'sabnzbd',
        mode   => '0644',
    }
    file { "${sabnzbd::params::scripts_dir}/":
        ensure => directory,
        owner  => 'sabnzbd',
        group  => 'sabnzbd',
        mode   => '0644',
    }
}