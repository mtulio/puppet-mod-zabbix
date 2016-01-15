# == Class: zabbix
#
# Class to manage Zabbix.
#
class zabbix (
  $agent_dir     = $zabbix::params::agent_dir,
  $agent_package = $zabbix::params::agent_package,
  $agent_service = $zabbix::params::agent_service,
  $repository    = $zabbix::params::repository,
  $server        = $zabbix::params::server
) inherits zabbix::params {
  #include zabbix::params

  ## See class zabbix::agent
}
