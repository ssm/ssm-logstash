# logstash::config
#
# A logstash instance defines a logstash service instance, and an
# empty configuration file. To include your own configuration, add
# logstash::config resources.
#
# The logstash::config is a wrapper around puppetlabs-concat, and
# takes the same parameters, except for "target", which is replaced by
# "instance". "instance" should refer to a named "logstash::instance".
#
# Example
#
#   logstash::instance { 'test':
#   }
#
#   logstash::config { 'test input one':
#     content => template('...')
#     target  => 'logstash::instance::test'
#   }

define logstash::config (
  $instance,
  $ensure  = 'present',
  $order   = undef,
  $content = undef,
  $source  = undef,
) {
  # Validate title and parameters
  validate_re($instance, '^[[:alnum:]]+$')
  validate_re($ensure, '^(present|absent)$')

  concat::fragment { "logstash::config::${instance}::${title}":
    ensure  => $ensure,
    order   => $order,
    content => $content,
    source  => $source,
    target  => "logstash::instance::${instance}",
  }
}
