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
	
	$dir_scan_dir = "/usr/local/SABnzbd-downloads/listen"
	$complete_dir = "/usr/local/SABnzbd-downloads/complete"
	$downloads_dir = "/usr/local/SABnzbd-downloads/incomplete"
	$script_dir = "/usr/local/sickbeard/autoProcessTV/"
	
	file { "/usr/local/SABnzbd-$version/sabnzbd.ini":
		content => template('sabnzbd/sabnzbd.ini.erb'),
		owner => 'root',
		group => 'root',
		mode => '0644',
	}
	
}
