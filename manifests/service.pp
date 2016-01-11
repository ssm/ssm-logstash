# == Class logstash::service
#
# This class is meant to be called from logstash.
# It ensure the service is running.
#
class logstash::service {

  service { $::logstash::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
