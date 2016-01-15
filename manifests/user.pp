# Class Zabbix user, ensure that zabbix user exists.
# Not meant to be used on its own
class zabbix::user {
  # Zabbix user 
  user { 'zabbix':
    ensure => 'present',
  }
}

