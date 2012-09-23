class sabnzbd( $source = 'true' ) {
	
	$version = "0.6.10"
	$package = "SABnzbd-#{version}.tar.gz"
	$url = "http://downloads.sourceforge.net/project/sabnzbdplus/sabnzbdplus/0.7.3/SABnzbd-0.7.3-src.tar.gz"
	
	include sabnzbd::config
	
	exec { 'download-sabnzbd':
        command => "/usr/bin/curl -L -o #{$package} #{$url}",
        cwd     => '/var/tmp',
        creates => "/var/tmp/#{$package}",
		#onlyif
    }
	
	file { "/usr/local/SABnzbd-#{$version}":
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0644',
	}
	
	exec { 'unpackage-sabnzbd':
		command => "/bin/tar xzf /var/tmp/#{$package}",
		cwd     => "/usr/local",
		creates => "/usr/local/SABnzbd-#{$version}"
	}
	
	file { "/usr/local/SABnzbd":
	    ensure => link,
        target => "/usr/local/SABnzbd-#{$version}",
	}	
}
