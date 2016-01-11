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

* Services logstash-${instance}
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
    }


Usage
=====

Put the classes, types, and resources for customizing, configuring,
and doing the fancy stuff with your module here.

* class logstash

* define logstash::instance


Reference
=========

To be referenced

Development
===========

See CONTRIBUTING.rst for how to contribute to this module
