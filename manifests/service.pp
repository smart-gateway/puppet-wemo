# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wemo::service
class wemo::service {
  case $wemo::ensure {
    'present', 'running', 'enabled': {
      # Ensure the service is enabled and running
      service { 'wanemd':
        ensure => running,
        enable => true,
      }
    }
    'stopped': {
      # Ensure the service is stopped and disabled
      service { 'wanemd':
        ensure => stopped,
        enable => true,
      }
    }
    'disabled': {
      # Ensure the service is stopped and disabled
      service { 'wanemd':
        ensure => stopped,
        enable => false,
      }
    }
    'absent': {
      # Ensure the service is stopped and disabled
      service { 'wanemd':
        ensure => stopped,
        enable => false,
      }
    }
    default: {
      fail("Invalid value for ensure: '${wemo::ensure}'.")
    }
  }
}
