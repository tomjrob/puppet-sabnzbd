class sabnzbd( $source = 'true' ) {
	
	$version = "0.7.3"
	$package = "SABnzbd-$version.tar.gz"
	$url = "http://downloads.sourceforge.net/project/sabnzbdplus/sabnzbdplus/$version/SABnzbd-$version-src.tar.gz"
	
	include sabnzbd::config
	
	user { 'sabnzbd':
        allowdupe => false,
        ensure => 'present',
        uid => '600',
        shell => '/bin/bash',
        gid => '600',
        home => '/home/sabnzbd',
        password => '*',
    }
    
    group { "sabnzbd":
        allowdupe => false,
        ensure => present,
        gid => 600,
        name => 'sabnzbd',
        before => User["sabnzbd"]
    }

	exec { 'download-sabnzbd':
        command => "/usr/bin/curl -L -o $package $url",
        cwd     => '/usr/local',
        creates => "/usr/local/$package",
    }
	
	exec { 'unpackage-sabnzbd':
		command => "/bin/tar xzf /usr/local/$package",
		cwd     => "/usr/local",
		creates => "/usr/local/SABnzbd-$version",
		user    => "sickbeard",
        group   => "sickbeard",
        before => File["/usr/local/SABnzbd-$version"]
	}
	
	file { "/usr/local/SABnzbd-$version":
		ensure => directory,
		owner => 'sabnzbd',
		group => 'sabnzbd',
		recurse => 'true',
		require => Exec["unpackage-sabnzbd"]
	}
	
	file { "/usr/local/SABnzbd":
	    ensure => link,
        target => "/usr/local/SABnzbd-$version",
	}
	
	file { "/etc/init.d/sabnzbd":
        content => template('sabnzbd/init-rhel.erb'),
        owner => 'root',
        group => 'root',
        mode => '0755',
    }	
}
