class sabnzbd::config {
	
	if $logrotate {
	    logrotate::rule { 'sabnzbd':
	        path          => "$log_dir/*",
	        rotate        => 5,
	        size          => '100k',
	        sharedscripts => true,
	        postrotate    => '/usr/bin/supervisorctl restart sabnzbd',
	    }   
	}
	    
	file { "$base_dir/sabnzbd/config/":
		ensure => directory,
	    owner => 'sabnzbd',
	    group => 'sabnzbd',
	}
    
    file { "/usr/local/sabnzbd/sabnzbd.ini":
        content => template('sabnzbd/sabnzbd.ini.erb'),
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
        require => File["$base_dir/sabnzbd/config/"],
        notify => Service['supervisor::sabnzbd'],
    }
    
    file { "$cache_dir":
        ensure => directory,
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
    }
    file { "$scripts_dir":
        ensure => directory,
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
    }

    file { "$scripts_dir/autoProcessTV.py":
        ensure => link,
        target => "$base_dir/sickbeard/src/autoProcessTV/autoProcessTV.py",
        require => Exec['download-sickbeard'],
    }

    file { "$scripts_dir/autoProcessTV.cfg":
        ensure => link,
        target => "$base_dir/sickbeard/config/autoProcessTV.cfg",
        require => File["$scripts_dir","$base_dir/sickbeard/config/autoProcessTV.cfg"]
    }
    
    file { "$scripts_dir/sabToSickBeard.py":
        ensure => link,
        target => "$base_dir/sickbeard/src/autoProcessTV/sabToSickBeard.py",
        require => Exec['download-sickbeard'],
    }    
}
