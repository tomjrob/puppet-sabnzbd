class sabnzbd::proxy inherits sabnzbd::params {
    if defined($proxy_nginx) {
        include nginx
        nginx::resource::upstream { 'sabnzbd':
            ensure  => present,
            members => "$sabnzbd_host:$sabnzbd_port",
        }
        nginx::resource::location { 'sabnzbd':
            ensure   => present,
            proxy  => 'http://sabnzbd',
            location => "$sabnzbd_webroot",
            vhost    => "$external_dns",
        }
    }
}