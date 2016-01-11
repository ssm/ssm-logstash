# == Class logstash::install
#
# This class is called from logstash for install.
#
class logstash::install {

  package { $::logstash::package_name:
    ensure => present,
  }
}
