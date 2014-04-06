class sabnzbd::install_deps inherits sabnzbd {
  exec { "sab_apt_update":
    command => '/usr/bin/apt-get -y update',
    path => "/usr/bin/",
    onlyif => "test \\( ! -f /var/cache/apt/pkgcache.bin \\) -o \\( ! -z `/usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin -print -quit` 1> /dev/null 2>/dev/null \\)",
    }
  
  ensure_resource('class', 'python', {
    'pip'  => true,
    'virtualenv' => true,
    'dev' => true
    })
  
  # Install Package Dependencies
  ensure_resource("package", $package_deps, {
    "ensure" => "installed"
    })
}