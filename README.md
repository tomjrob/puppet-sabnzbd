Puppet module for installing [sabnzbd](http://sabnzbd.org/).

[![BuildStatus](https://api.travis-ci.org/liamjbennett/puppet-sabnzbd.png)](https://travis-ci.org/liamjbennett/puppet-sabnzbd)
[![Dependency Status](https://gemnasium.com/liamjbennett/puppet-sabnzbd.png)](https://gemnasium.com/liamjbennett/puppet-sabnzbd)

## Usage

The module includes a single class:

    include 'sabnzbd'

This installs sabnzbd, along with all required dependencies. If nginx is included in your manifest then it will also create the appropriate configuration. You can also update the sabnzbd config with hiera.