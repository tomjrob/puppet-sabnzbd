source "http://rubygems.org"

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'rake'
gem 'puppet', puppetversion
gem 'puppet-lint', '>= 0.3.2'
gem 'rspec-puppet', '>= 0.1.5'
gem 'puppetlabs_spec_helper', '>= 0.4.0'
gem 'hiera-puppet', '>= 1.0.0'
