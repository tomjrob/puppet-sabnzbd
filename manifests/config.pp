class sabnzbd::config {
    
    $api_key = extlookup("api_key")
    $email_to = extlookup("email")
    $email_account = extlookup("email")
    $email_server = extlookup("email_server")
    $email_from = extlookup("email")
    $email_passwd = extlookup("email_passwd")
    $nzb_key = extlookup("nzb_key")
    $server_uname = extlookup("nzb_server_uname")
    $server_addr = extlookup("nzb_server_addr")
    $server_passwd = extlookup("nzb_server_passwd")
    
    $dir_scan_dir = "/usr/local/sabnzbd-downloads/listen"
    $complete_dir = "/usr/local/sabnzbd-downloads/complete"
    $downloads_dir = "/usr/local/sabnzbd-downloads/incomplete"
    $scripts_dir = "/usr/local/sabnzbd/scripts"
    
    file { "/usr/local/sabnzbd/sabnzbd.ini":
        content => template('sabnzbd/sabnzbd.ini.erb'),
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
        require => Exec['download-sabnzbd']
    }
    
    $script_dir = "/usr/local/sabnzbd/scripts"
    
    file { '/usr/local/sabnzbd/scripts':
        ensure => directory,
        owner => 'sabnzbd',
        group => 'automators',
        mode => '0644',
    }

	file { '/usr/local/sabnzbd/scripts/autoProcessTV':
        ensure => directory,
        owner => 'sabnzbd',
        group => 'automators',
        mode => '0644',
        require => File["/usr/local/sickbeard"]
    }

    file { '/usr/local/sabnzbd/scripts/autoProcessTV/autoProcessTV.py':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/autoProcessTV.py",
        require => File["/usr/local/sickbeard/autoProcessTV"]
    }
    
    file { '/usr/local/sabnzbd/scripts/autoProcessTV/autoProcessTV.cfg':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/autoProcessTV.cfg",
        require => File["/usr/local/sickbeard/autoProcessTV"]
    }
    
    file { '/usr/local/sabnzbd/scripts/autoProcessTV/sabToSickBeard.py':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/sabToSickBeard.py",
        require => File["/usr/local/sickbeard/autoProcessTV"]
    }
    
}
