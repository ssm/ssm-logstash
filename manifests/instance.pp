# Logstash instance
#
# A logstash instance defines a logstash service instance, and an
# empty configuration file. To include your own configuration, add
# logstash::config resources.
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

define logstash::instance (
  $ensure = 'present',
)
{

  # Validate title and parameters
  validate_re($title, '^[[:alnum:]]+$')
  validate_re($ensure, '^(present|absent)$')

  $concat_path="/etc/logstash/${title}.conf"
  validate_absolute_path($concat_path)

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
    path   => $concat_path,
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
