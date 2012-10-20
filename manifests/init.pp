class sabnzbd {
	
	$url = "https://github.com/sabnzbd/sabnzbd.git"
	
	include sabnzbd::config
	
	user { 'sabnzbd':
        allowdupe => false,
        ensure => 'present',
        uid => '600',
        shell => '/bin/bash',
        gid => '700',
        home => '/home/sabnzbd',
        password => '*',
    }

    file { '/home/sabnzbd':
        ensure => directory,
        owner => 'sabnzbd',
        group => 'automators',
        mode => '0644',
        recurse => 'true'
    }

    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url sabnzbd",
        cwd     => '/usr/local',
        creates => "/usr/local/sabnzbd",
    }
	
	file { "/usr/local/sabnzbd":
		ensure => directory,
		owner => 'sabnzbd',
		group => 'automators',
		mode => '0644',
		recurse => 'true',
	}
	
	file { "/etc/init.d/sabnzbd":
        content => template('sabnzbd/init-rhel.erb'),
        owner => 'root',
        group => 'root',
        mode => '0755',
    }	
}
