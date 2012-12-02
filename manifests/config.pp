class sabnzbd::config {
    
    $api_key = hiera('sabnzbd_apikey')
    $email_to = hiera('email')
    $email_account = hiera('email')
    $email_server = hiera('email_server')
    $email_from = hiera('email')
    $email_passwd = hiera('email_passwd')
    $nzb_key = hiera('sabnzbd_nzbkey')
    $server_uname = hiera('nzb_server_uname')
    $server_addr = hiera('nzb_server_addr')
    $server_passwd = hiera('nzb_server_passwd')
    
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
        require => File["/usr/local/sickbeard"]
    }

    file { '/usr/local/sabnzbd/scripts/autoProcessTV.py':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/autoProcessTV.py",
        require => File["/usr/local/sabnzbd/scripts"]
    }
    
    file { '/usr/local/sabnzbd/scripts/autoProcessTV.cfg':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/autoProcessTV.cfg",
        require => File["/usr/local/sabnzbd/scripts"]
    }
    
    file { '/usr/local/sabnzbd/scripts/sabToSickBeard.py':
        ensure => link,
        target => "/usr/local/sickbeard/autoProcessTV/sabToSickBeard.py",
        require => File["/usr/local/sabnzbd/scripts"]
    }
    
}
