#
#
#
class sabnzbd::params {
    $base_dir = '/opt'
    $url = 'https://github.com/sabnzbd/sabnzbd.git'
    $service_manage = true
    $service_enable = true
    $service_ensure = present
    $user = sabnzbd
    $group = sabnzbd
    
    $venv_dir = "${base_dir}/sabnzbd/venv"
    $log_dir = "${base_dir}/sabnzbd/log"
    $config_dir = "${base_dir}/sabnzbd/config"
    $src_dir = "${base_dir}/sabnzbd/src"
    
    $package_deps = ['git','unrar','unzip','p7zip','par2','python-yenc', 'libssl-dev']
    $pip_deps = ['pyOpenSSL','cheetah']
}