#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with logstash](#setup)
    * [What logstash affects](#what-logstash-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with logstash](#beginning-with-logstash)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install and configure logstash instances

## Module Description

This module installs and configures logstash instances.

## Setup

### What logstash affects

* Services logstash-${instance}
* Files under /etc/logstash/${instance}.conf.d/

### Setup Requirements **OPTIONAL**

This module does not provide a repository for logstash,

You need to provide a repository (yumrepo, apt::repository) for
Logstash in a separate module, and ensure it is used before this
module.

### Beginning with logstash

Configure a repository in your profile, and include the logstash class.

    class profile::logstash {
        include ::logstash

        yumrepo { 'logstash':
            ....
        }
        Yumrepo['logstash'] -> Class['logstash']
    }

## Usage

Put the classes, types, and resources for customizing, configuring,
and doing the fancy stuff with your module here.

* class logstash

* define logstash::instance

## Reference

## Development

See CONTRIBUTING.md for how to contribute to this module
