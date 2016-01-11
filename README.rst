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

This module does not provide a repository for logstash,

You need to provide a repository (yumrepo, apt::repository) for
Logstash in a separate module, and ensure it is used before this
module.


Beginning with logstash
-----------------------

Configure a repository in your profile, and include the logstash class.

.. code-block:: puppet

    class profile::logstash {
        include ::logstash

        yumrepo { 'logstash':
            # [...]
        }

        Yumrepo['logstash'] -> Class['logstash']

        logstash::instance { 'shipper': }

        Logstash::Config {
            instance => 'shipper',
        }
        logstash::config { 'input':
            source   => 'puppet:///profile/logstash/input.conf'
        }
        logstash::config { 'filters':
            source   => 'puppet:///profile/logstash/filters.conf'
        }
        logstash::config { 'output':
            source   => 'puppet:///profile/logstash/output.conf'
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
