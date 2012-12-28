class sabnzbd inherits sabnzbd::params {
	
	include sabnzbd::config
	include sabnzbd::proxy
	include git
	include python::virtualenv
	include supervisor
	
	package {
	   'unrar':
	       ensure => 'installed';
	   'unzip':
	       ensure => 'installed';
	   'p7zip':
	       ensure => 'installed';
	    'par2':
	        ensure => 'installed';
	    'python-yenc':
	        ensure => 'installed';
	}
	
	user { 'sabnzbd':
        allowdupe => false,
        ensure => 'present',
        uid => '600',
        shell => '/bin/bash',
        gid => '700',
        home => "$base_dir/sabnzbd",
        password => '*',
    }

    file { '$base_dir/sabnzbd':
        ensure => directory,
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
        recurse => 'true'
    }

	exec { 'venv-create-sabnzbd':
	    command => "virtualenv $venv_dir",
	    cwd => "$base_dir/sabnzbd",
	    creates => "$base_dir/sabnzbd/$venv_dir/bin/activate",
	    path => '/usr/bin/',
	    user => 'sabnzbd',
	    require => [Class['python::virtualenv'], Package['python-yenc']];
	}
	exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url src",
        cwd     => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/src",
        user => 'sabnzbd',
        require => Class['git'],
    }
	exec { 'install-pyopenssl':
	    command => "$base_dir/sabnzbd/venv/bin/pip install pyOpenSSL",
	    cwd => "$base_dir/sabnzbd/venv",
	    creates => "$base_dir/sabnzbd/venv/lib/python2.7/site-packages/OpenSSL",
	    path => "$base_dir/sabnzbd/venv/bin",
	    user => 'sabnzbd',
	    require => Exec['venv-create-sabnzbd'];
	}
	exec { 'install-cheetah-sabnzbd':
	    command => "$base_dir/sabnzbd/venv/bin/pip install cheetah",
	    cwd => "$base_dir/sabnzbd/venv",
	    creates => "$base_dir/sabnzbd/venv/bin/cheetah",
	    path => "$base_dir/sabnzbd/venv/bin",
	    user => 'sabnzbd',
	    require => Exec['venv-create-sabnzbd'];
	}
	
	if defined(Class['supervisor::service']) {
		supervisor::service {
	    	'sabnzbd':
	        	ensure => present,
	        	enable => true,
	        	stdout_logfile => "$base_dir/sabnzbd/log/supervisor.log",
	        	stderr_logfile => "$base_dir/sabnzbd/log/supervisor.log",
	        	command => "$base_dir/sabnzbd/venv/bin/python $base_dir/sabnzbd/src/SABnzbd.py -f $base_dir/sabnzbd/config/sabnzbd.ini",
	        	user => 'sabnzbd',
	        	group => 'sabnzbd',
	        	directory => "$base_dir/sabnzbd/src/",
	        	require => Exec['download-sabnzbd'],
		}	
	}
}