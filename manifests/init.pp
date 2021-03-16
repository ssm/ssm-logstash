# Class: logstash
# ===========================
#
# Full description of class logstash here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class logstash (
  $package_name = $::logstash::params::package_name,
)
inherits ::logstash::params {

  # validate parameters here

  anchor { 'logstash::begin': }
  
  -> class { '::logstash::install': }
  
  -> anchor { 'logstash::end': }

  Logstash::Instance <| |> {
    require => Class['logstash::install'],
    before  => Anchor['logstash::end'],
  }
}
