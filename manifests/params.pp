#
#
#
class sabnzbd::params {
    $base_dir = '/opt/sabnzbd'
    $url = 'https://github.com/sabnzbd/sabnzbd.git'
    $service_manage = true
    $service_enable = true
    $service_ensure = present
    $user = sabnzbd
    $group = sabnzbd
    
    $venv_dir = "${base_dir}/venv"
    $log_dir = "${base_dir}/log"
    $config_dir = "${base_dir}/config"
    $src_dir = "${base_dir}/src"
    
    $package_deps = ['git','unrar','unzip','p7zip','par2','python-yenc', 'libssl-dev']
    $pip_deps = ['pyOpenSSL','cheetah']
}