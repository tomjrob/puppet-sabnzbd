#
#
#
class sabnzbd::proxy {
  include sabnzbd::params

  if defined(Class['nginx']) and $sabnzbd::params::proxy_nginx {
    include nginx
    nginx::resource::upstream { 'sabnzbd':
      ensure  => present,
      members => "${sabnzbd::params::sabnzbd_host}:${sabnzbd::params::sabnzbd_port}",
    }
    nginx::resource::location { 'sabnzbd':
      ensure   => present,
      proxy    => 'http://sabnzbd',
      location => "${sabnzbd::params::sabnzbd_webroot}/",
      vhost    => "${sabnzbd::params::external_dns}/",
    }
  }
}