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
)
{

  # Validate title and parameters
  validate_re($title, '^[[:alnum:]]+$')

  concat { "logstash::instance::${title}":
    path   => "/etc/logstash/${title}.conf",
    notify => Service["logstash@${title}"],
  }

  file { "/etc/systemd/system/logstash@${title}.service":
    ensure => link,
    target => '/etc/systemd/system/logstash@.service',
    before => Service["logstash@${title}"],
  }

  service { "logstash@${title}":
    ensure => running,
    enable => true,
  }
}
