============================
 Puppet module ssm-logstash
============================

Overview
========

Install and configure logstash instances

.. contents::


Module Description
==================

This module installs and configures logstash instances.


Setup
=====


What logstash affects
---------------------

* systemd instances logstash@${instance}
* Files under /etc/logstash/${instance}.conf.d/


Setup Requirements
------------------

* You need to provide a repository (yumrepo, apt::repository) for
  Logstash, and ensure it is enforced before this class.

* You need to ensure "java" is installed on the server, and ensure it
  is enforced before this class.


Beginning with logstash
-----------------------

Configure a logstash profile.

Add a package repository, install java, and then install and configure
logstash.

.. code-block:: puppet

    class profile::logstash {

        # Repo
        yumrepo { 'logstash':
            descr    => 'logstash repo for centos',
            baseurl  => 'https://packages.elastic.co/logstash/2.1/centos',
            gpgcheck => '1',
            enabled  => '1',
            gpgkey   => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
        }
        Yumrepo['logstash'] -> Class['logstash']

        # Dependencies
        class { '::java': distribution => 'jre' }
        Package['java'] -> Class['logstash']

        # Install and configure Logstash
        class { '::logstash': }

        logstash::instance { 'shipper': }

        Logstash::Config {
            instance => 'shipper',
        }
        logstash::config { 'input':
            content   => 'input { syslog { port => 10514 } }'
        }
        logstash::config { 'filters':
            source   => 'puppet:///profile/logstash/filters.conf'
        }
        logstash::config { 'output':
            source   => 'output { elasticsearch { } }'
        }
    }


Usage
=====

class logstash
--------------

Base class, installs logstash.  One parameter:

* package_name: The package name to install. Default: "logstash"

defined type logstash::instance
-------------------------------

Defines a logstash instance. Parameters:

* ensure: "present" or "absent". Default: "present"

defined type logstash::config
------------------------------

Defines a fragment of configuration for a logstash instance. Parameters:

* instance: Refers to a defined logstash instance. Required, no
  default.

* ensure: "present" or "absent". Default: "present"

Reference
=========

To be referenced

Development
===========

See CONTRIBUTING.rst for how to contribute to this module
