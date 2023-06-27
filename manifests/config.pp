# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include wemo::config
class wemo::config {
  case $wemo::ensure {
    'present', 'running', 'stopped', 'enabled', 'disabled': {
      # Create symlinks for the tools
      if $wemo::install_tools {
        file { '/usr/local/bin/wemo':
          ensure => link,
          target => '/opt/wanemd/bin/wemo',
        }

        file { '/usr/local/bin/wemo-setup':
          ensure => link,
          target => '/opt/wanemd/bin/wemo-setup',
        }

        file { '/usr/local/bin/wemo-log-watcher':
          ensure => link,
          target => '/opt/wanemd/bin/wemo-log-watcher',
        }
      }

      # Create and configure the configuration file from template
      if $wemo::install_service {
        file { '/etc/wanemd/wanemd.yaml':
          ensure  => file,
          content => epp('wemo/wanemd.yaml.epp', {
              'uplink_interface'       => $wemo::uplink_interface,
              'downlink_interface'     => $wemo::downlink_interface,
              'bridge_name'            => $wemo::bridge_name,
              'line_rate'              => $wemo::line_rate,
              'flush_iptables_forward' => $wemo::flush_iptables_forward,
          }),
          mode    => '0644',
        }

        # Create and configure the systemd service file from template
        file { '/etc/systemd/system/wanemd.service':
          ensure  => file,
          content => epp('wemo/wanemd.service.epp'),
          mode    => '0644',
          notify  => Service['wanemd'],
        }
      }
    }
    'absent': {
      # Remove the configuration file if present
      file { '/etc/wanemd/wanemd.yaml':
        ensure => absent,
        # Additional file attributes as needed
      }

      # Remove the systemd service file if present
      file { '/etc/systemd/system/wanemd.service':
        ensure => absent,
        # Additional file attributes as needed
        notify => Service['wanemd'],
      }

      # Remove the symbolic links
      file { '/usr/local/bin/wemo':
        ensure => absent,
      }

      file { '/usr/local/bin/wemo-setup':
        ensure => absent,
      }

      file { '/usr/local/bin/wemo-log-watcher':
        ensure => absent,
      }
    }
    default: {
      fail("Invalid value for ensure: '${wemo::ensure}'.")
    }
  }
}
