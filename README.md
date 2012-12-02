puppet-sabnzbd
==============
Puppet module to install sabnzbd.

It relies on sickbeard, hiera and git.

https://github.com/puppetlabs/hiera
https://github.com/josephmc5/puppet-git.git
https://github.com/josephmc5/puppet-sickbeard
https://github.com/jfryman/puppet-nginx.git

Clone both of the above into /etc/puppet/modules/

You will need a hiera.yaml. For example:
<pre>
:hierarchy:
    - %{operatingsystem}
    - common
:backends:
    - yaml
:yaml:
    :datadir: '/etc/puppet/hieradata'
</pre>

Then create a common.yaml in the datadir you specified above:
<pre>
external_dns : ''                                        
sabnzbd_host : 'localhost'
sabnzbd_port : '8080'
sabnzbd_ssl : '0' 
sabnzbd_api_key : ''
sabnzbd_nzb_key : ''
sabnzbd_webroot : '/sabnzbd'
app_dir : '/opt'
email_to : ''
email_server : ''
email_passwd : ''
email_from : ''
nzb_scan_dir : ''
complete_download_dir : '/media/watcher/download/complete'
complete_movie_download_dir : '/media/watcher/download/complete/movies'
complete_music_download_dir : '/media/watcher/download/complete/music'
complete_tv_download_dir : '/media/watcher/download/complete/music'
incomplete_download_dir : '/media/watcher/download/incomplete'
nzb_server : 'news.giganews.com'
nzb_server_username : ''
nzb_server_passwd : ''
nzb_server_port : '563'
nzb_server_retention : '1551'
nzb_server_maxconnections : '20'
nzb_server_ssl : '1' 
enable_growl : '1' 
nzbmatrix_username : ''
nzbmatrix_apikey : ''

sabnzbd_apikey : ''
sickbeard_host : 'locahost'
sickbeard_port : '8081'
sickbeard_webroot : '/tv'

plex_server_host : 'localhost'
</pre>