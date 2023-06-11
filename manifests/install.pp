# == Class logstash::install
#
# This class is called from logstash for install.
#
class logstash::install {
  package { $logstash::package_name:
    ensure => present,
  }

  file { '/etc/systemd/system/logstash.target':
    source => 'puppet:///modules/logstash/logstash.target',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  service { 'logstash':
    ensure => 'stopped',
    enable => false,
  }

  file { '/etc/init.d/logstash':
    ensure  => absent,
    require => Service['logstash'],
  }
  file { '/etc/default/logstash':
    ensure  => absent,
    require => Service['logstash'],
  }
}
