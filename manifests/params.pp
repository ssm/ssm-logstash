# == Class logstash::params
#
# This class is meant to be called from logstash.
# It sets variables according to platform.
#
class logstash::params {
  case $facts['os']['family'] {
    'Debian': {
      $package_name = 'logstash'
    }
    'RedHat': {
      $package_name = 'logstash'
    }
    default: {
      fail("${facts['os']['name']} not supported")
    }
  }
}
