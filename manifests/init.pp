# @summary A Puppet class for managing WEMO, a WAN emulation and optimization tool.
#
# This class provides functionality to manage the WEMO tool, which is used for WAN emulation and optimization.
#
# @param ensure (Enum['present', 'absent', 'running', 'stopped', 'enabled', 'disabled']) The desired state of the WEMO resource.
#   - 'present': Ensures that the WEMO resource is present or installed. Default value.
#   - 'absent': Ensures that the WEMO resource is absent or removed.
#   - 'running': Ensures that the WEMO service or process is running.
#   - 'stopped': Ensures that the WEMO service or process is stopped.
#   - 'enabled': Ensures that the WEMO service or resource is enabled.
#   - 'disabled': Ensures that the WEMO service or resource is disabled.
#
# @param uplink_interface (String) The WAN-side interface for WEMO.
#   Specify the interface used for WAN traffic emulation and optimization.
#
# @param downlink_interface (String) The LAN-side interface for WEMO.
#   Specify the interface used for LAN traffic emulation and optimization.
#
# @param install_tools (Boolean) The WEMO command line tools.
#   Specify if the command line tools should be installed.
#
# @param install_service (Boolean) The WEMO emulation service.
#   Specify if the WEMO services should be installed. False will cause a tools only install.
#
# @param bridge_name (String) The name of the bridge interface.
#   Specify the name to use for the WEMO bridge interface that is created.
#
# @param line_rate (String) The line rate of the network interfaces.
#   Specify the line rate for the network interfaces. TODO: Uplink and Downlink should be seperate and should be populated from facts if possible.
#
# @param flush_iptables_forward (Boolean) The forward table of iptables should be flushed.
#   Specify if the forward table of iptables should have all rules flushed
# @example
#   # Install and enable WEMO on eth0 as the uplink interface and eth1 as the downlink interface
#   class { 'wemo':
#     ensure              => 'present',
#     uplink_interface    => 'eth0',
#     downlink_interface  => 'eth1',
#   }
#
#   # Remove WEMO from the system
#   class { 'wemo':
#     ensure              => 'absent',
#     uplink_interface    => 'eth0',
#     downlink_interface  => 'eth1',
#   }
class wemo (
  String $uplink_interface,
  String $downlink_interface,
  Enum['present', 'absent', 'running', 'stopped', 'enabled', 'disabled'] $ensure = 'present',
  Boolean $install_tools = true,
  Boolean $install_service = true,
  String  $bridge_name = 'br0',
  String  $line_rate = '1000mbit',
  Boolean $flush_iptables_forward = true,
) {
  validate_string($uplink_interface)
  validate_string($downlink_interface)

  # Ensure that the interfaces are valid on the system.
  $available_interfaces = $facts['networking']['interfaces'].keys

  if !($available_interfaces.include?($uplink_interface)) {
    fail("Invalid value for uplink_interface: '${uplink_interface}'. The specified interface does not exist.")
  }

  if !($available_interfaces.include?($downlink_interface)) {
    fail("Invalid value for downlink_interface: '${downlink_interface}'. The specified interface does not exist.")
  }

  # Ensure class declares subordinate classes
  contain wemo::install
  contain wemo::config
  contain wemo::service

  # Ensure execution ordering
  Class['wemo::install']
  -> Class['wemo::config']
  -> Class['wemo::service']

  case $ensure {
    'present': {
      # Logic to ensure the resource is present or installed
      notify { 'Wemo is present': }
      # Add resource declarations or code as needed
    }

    'absent': {
      # Logic to ensure the resource is absent or removed
      notify { 'Wemo is absent': }
      # Add resource declarations or code as needed
    }

    'running': {
      # Logic to ensure the service or process is running
      notify { 'Wemo is running': }
      # Add resource declarations or code as needed
    }

    'stopped': {
      # Logic to ensure the service or process is stopped
      notify { 'Wemo is stopped': }
      # Add resource declarations or code as needed
    }

    'enabled': {
      # Logic to ensure the service or resource is enabled
      notify { 'Wemo is enabled': }
      # Add resource declarations or code as needed
    }

    'disabled': {
      # Logic to ensure the service or resource is disabled
      notify { 'Wemo is disabled': }
      # Add resource declarations or code as needed
    }

    default: {
      fail("Invalid value for ensure: '${ensure}'.")
    }
  }
}
