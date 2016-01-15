# Param class, not meant to be used on its own.
## Not used, yet!
class zabbix::params {
  $agent_dir     = undef
  $agent_package = 'zabbix-agent'
  $agent_service = 'zabbix-agent'
  $repository    = 'http://repo.zabbix.com'
  $server        = 'zabbix.server.local'
}
