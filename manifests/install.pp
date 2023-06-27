# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wemo::install
class wemo::install {
  case $wemo::ensure {
    'present', 'running', 'stopped', 'enabled', 'disabled': {
      # Create directories if necessary
      file { '/opt/wanemd':
        ensure => directory,
        mode   => '0755',
      }

      file { '/opt/wanemd/bin':
        ensure => directory,
        mode   => '0755',
      }

      file { '/etc/wanemd':
        ensure => directory,
        mode   => '0700',
      }

      # Determine Ubuntu version
      $ubuntu_version = $facts['lsbdistcodename']

      # Copy files from the module's files directory to target locations
      if $wemo::install_service {
        file { '/opt/wanemd/bin/wanemd':
          ensure => file,
          source => "puppet:///modules/wemo/ubuntu-${ubuntu_version}/bin/wanemd",
          mode   => '0755',
        }
      }

      if $wemo::install_tools {
        file { '/opt/wanemd/bin/wemo':
          ensure => file,
          source => "puppet:///modules/wemo/ubuntu-${ubuntu_version}/bin/wemo",
          mode   => '0755',
        }

        file { '/opt/wanemd/bin/wemo-setup':
          ensure => file,
          source => "puppet:///modules/wemo/ubuntu-${ubuntu_version}/bin/wemo-setup",
          mode   => '0755',
        }

        file { '/opt/wanemd/bin/wemo-log-watcher':
          ensure => file,
          source => "puppet:///modules/wemo/ubuntu-${ubuntu_version}/bin/wemo-log-watcher",
          mode   => '0755',
        }
      }
    }
    'absent': {
      # Remove directories and files if present
      file { ['/opt/wanemd/bin', '/opt/wanemd', '/etc/wanemd']:
        ensure => absent,
        force  => true,
      }
    }
    default: {
      fail("Invalid value for ensure: '${wemo::ensure}'.")
    }
  }
}
