Puppet module for installing [sickbeard](http://sickbeard.org/).

[![Build Status](https://travis-ci.org/tomo0/puppet-sickbeard.png?branch=master)](https://travis-ci.org/tomo0/puppet-sickbeard)

## Usage

The module includes a single class:

    include 'sickbeard'

This installs sickbeard, along with all required dependencies. If nginx is included in your manifest then it will also create the appropriate configuration. You can also update the sickbeard config with hiera.