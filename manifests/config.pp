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

    file { '/usr/local/sabnzbd/sabnzbd.ini':
        content => template('sabnzbd/sabnzbd.ini.erb'),
        owner   => 'sabnzbd',
        group   => 'sabnzbd',
        mode    => '0644',
        require => File["${sabnzbd::params::base_dir}/sabnzbd/config/"],
        notify  => Service["Supervisor::Service['sabnzbd']"],
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

#    file { "${sabnzbd::params::scripts_dir}/autoProcessTV.py":
#        ensure  => link,
#        target  => "${sabnzbd::params::base_dir}/sickbeard/src/autoProcessTV/autoProcessTV.py",
#        require => Exec['download-sickbeard'],
#    }
#
#    file { "${sabnzbd::params::scripts_dir}/autoProcessTV.cfg":
#        ensure  => link,
#        target  => "${sabnzbd::params::base_dir}/sickbeard/config/autoProcessTV.cfg",
#        require => File["${sabnzbd::params::scripts_dir}/","${sabnzbd::params::base_dir}/sickbeard/config/autoProcessTV.cfg"]
#    }
#
#    file { "${sabnzbd::params::scripts_dir}/sabToSickBeard.py":
#        ensure  => link,
#        target  => "${sabnzbd::params::base_dir}/sickbeard/src/autoProcessTV/sabToSickBeard.py",
#        require => Exec['download-sickbeard'],
#    }
}