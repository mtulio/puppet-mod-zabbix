# Class Zabbix Agent - Package
class zabbix::agent::package (
  $agent_package = $agent_package,
) inherits zabbix {

  include zabbix::repo

  package {
    $agent_package : ensure => 'latest',
  }
}
