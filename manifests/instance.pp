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
#
# ensure: present | absent
#
# command: full path to logstash binary
#
# config_file: full path to logstash instance config
# (default: /etc/logstash/${title}.conf)
#
# user: user for running logstash (default: logstash)
#
# group: group for running logstash (default: logstash)
#
# workers: number of filter workers (default: '')
#
define logstash::instance (
  $ensure      = 'present',
  $command     = '/opt/logstash/bin/logstash',
  $config_file = "/etc/logstash/${title}.conf",
  $user        = 'logstash',
  $group       = 'logstash',
  $workers     = '',
) {
  # Validate title and parameters
  validate_re($title, '^[[:alnum:]]+$')
  validate_re($ensure, '^(present|absent)$')
  validate_absolute_path($command)
  validate_absolute_path($config_file)
  validate_string($user)
  validate_string($group)
  validate_re($workers, '^(\d+|)$')

  case $ensure {
    'present': {
      $concat_ensure    = 'present'
      $service_ensure   = 'running'
      $service_enable   = true
      $directory_ensure = 'directory'
      $file_ensure      = 'present'
      Concat["logstash::instance::${title}"]                ~> Service["logstash@${title}"]
      File["/etc/systemd/system/logstash@${title}.service"] ~> Service["logstash@${title}"]
    }
    'absent': {
      $concat_ensure    = 'absent'
      $service_ensure   = 'stopped'
      $service_enable   = false
      $directory_ensure = 'absent'
      $file_ensure      = 'absent'
      Service["logstash@${title}"] -> Concat["logstash::instance::${title}"]
      Service["logstash@${title}"] -> File["/etc/systemd/system/logstash@${title}.service"]
    }
    default: {
      fail("logstash::instance::${title}: internal error")
    }
  }

  concat { "logstash::instance::${title}":
    ensure       => $concat_ensure,
    path         => $config_file,
    validate_cmd => "${command} agent --configtest --config %",
    warn         => true,
  }

  file { "/etc/systemd/system/logstash@${title}.service":
    ensure  => $file_ensure,
    content => template('logstash/logstash@.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  service { "logstash@${title}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
