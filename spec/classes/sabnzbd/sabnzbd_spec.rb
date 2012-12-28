require 'spec_helper'

describe 'sabnzbd', :type => :class do
  it { should include_class('sabnzbd::config') }
  it { should include_class('sabnzbd::proxy') }
  it { should include_class('sabnzbd::git') }
  it { should include_class('python::virtualenv') }
  it { should contain_package('unrar').with_ensure('installed') }
  it { should contain_package('unzip').with_ensure('installed') }
  it { should contain_package('p7zip').with_ensure('installed') }
  it { should contain_package('par2').with_ensure('installed') }
  it { should contain_package('python-yenc').with_ensure('installed') }
end