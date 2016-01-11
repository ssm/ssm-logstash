# Logstash instance
#
# A logstash instance defines a logstash service instance, and a
# configuration file as a "concat" resource. To include your own
# configuration, add concat::fragment resources.
#
# Example
#
#   logstash::instance { 'test':
#   }
#
#   concat::fragment { 'logstash input':
#     content => template('...')
#     target  => 'logstash::instance::test'
#   }

define logstash::instance (
  $ensure = 'present',
)
{

  # Validate title and parameters
  validate_re($title, '^[[:alnum:]]+$')
  validate_re($ensure, '^(present|absent)$')

  case $ensure {
    'present': {
      $concat_ensure  = 'present'
      $service_ensure = 'running'
      $service_enable = true
      $file_ensure    = 'link'
      $file_target    = '/etc/systemd/system/logstash@.service'

      Concat["logstash::instance::${title}"]                ~> Service["logstash@${title}"]
      File["/etc/systemd/system/logstash@${title}.service"] ~> Service["logstash@${title}"]
    }
    'absent': {
      $concat_ensure  = 'absent'
      $service_ensure = 'stopped'
      $service_enable = false
      $file_ensure    = 'absent'
      $file_target    = undef
      Service["logstash@${title}"] -> Concat["logstash::instance::${title}"]
      Service["logstash@${title}"] -> File["/etc/systemd/system/logstash@${title}.service"]
    }
    default: {
      fail("logstash::instance::${title}: internal error")
    }
  }

  concat { "logstash::instance::${title}":
    ensure => $concat_ensure,
    path   => "/etc/logstash/${title}.conf",
  }

  file { "/etc/systemd/system/logstash@${title}.service":
    ensure => $file_ensure,
    target => $file_target,
  }

  service { "logstash@${title}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
