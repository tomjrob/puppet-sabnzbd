class sabnzbd( $source = 'true' ) {
	
	$version = "0.7.3"
	$package = "SABnzbd-$version.tar.gz"
	$url = "http://downloads.sourceforge.net/project/sabnzbdplus/sabnzbdplus/$version/SABnzbd-$version-src.tar.gz"
	
	include sabnzbd::config
	
	exec { 'download-sabnzbd':
        command => "/usr/bin/curl -L -o $package $url",
        cwd     => '/usr/local',
        creates => "/usr/local/$package",
    }
	
	file { "/usr/local/SABnzbd-$version":
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0644',
	}
	
	exec { 'unpackage-sabnzbd':
		command => "/bin/tar xzf /usr/local/$package",
		cwd     => "/usr/local",
		creates => "/usr/local/SABnzbd-$version",
        before => File["/usr/local/SABnzbd-$version"]
	}
	
	file { "/usr/local/SABnzbd":
	    ensure => link,
        target => "/usr/local/SABnzbd-$version",
	}	
}
