# Class Zabbix Agent Service
class zabbix::agent::service (
  $agent_service = $agent_service,
  $agent_package = $agent_package,
) inherits zabbix {

  # Config service    
  service { $agent_service:
    ensure  => 'running',
    enable  => true,
    require => Package[$agent_package],
  }
}
