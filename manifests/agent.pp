# == Class: zabbix::agent
#
# Class to manage Zabbix Agent (zabbix::agent)
#
# Allow you to configure each option of agent.
# All parameters default to undef, meaning that the original
# defaults are used.
#
# === Parameters
#
# Class to manage the main zabbix_agentd.conf file.
#
# [*opt_use_template*]
#   Must be set. This parameter set use of template. 
#   Default: yes
#
# [*server*]
#   This parameter set the local zabbix server. 
#   Default: $zabbix::params::server
#
# === Examples
#
## 1 - Using default template
# class { 'zabbix::agent': 
#	opt_use_template => 'yes',
#	server => 'your.zabbix.server',
# }
## 2 - Using custom template
# class { 'zabbix::agent': 
#	opt_use_template => 'yes',
#	server 		 => 'your.zabbix.server',
#	agent_template   => 'path/to/your/template.erb',
# }
## 3 - Using custom config options
# class { 'zabbix::agent': 
#	opt_use_template => 'no',
#	server		 => 'your.zabbix.server',
#	listen_port      => "$::ipaddress",
#	listen_ip        => '10050',
#	start_agents     => '2',
#	server_active    => 'your.zabbix.server',
#	buffers_send     => '10',
#	buffers_size     => '512',
# }
#
# === Authors
#
# Marco Túlio R Braga <git@mtulio.eng.br>
#
# === Copyright
#
# Copyright 2016 @mtulio
#
################################
class zabbix::agent (
  ## INHERITANCE ##
  $agent_package      = $agent_package,
  $agent_service      = $agent_service,

  ## GLOBALS [must be set] ##
  $opt_use_template   = 'yes',
  $firewall_enabled   = true,
  $selinux_mode       = 'permissive',
  $server             = $server,

  ## Option USE TEMPLETE ##
  $agent_template     = undef,

  ## Option DO NOT USE TEMPLATE ##
  ##> CONFIG FILE OPTIONS <##
  ### GENERAL PARAMETERS ###
  $pid_file        = undef,
  $log_file        = undef,
  $log_file_size   = undef,
  $debug_level     = undef,
  $source_ip       = undef,
  $en_remote_cmd   = undef,
  $log_remote_cmd  = undef,
  $listen_port     = undef,
  $listen_ip       = undef,
  $start_agents    = undef,
  $server_active   = undef,
  $hostname        = undef,
  $hostname_item   = undef,
  $host_metadata   = undef,
  $host_metadata_it= undef,
  $refresh_act_chk = undef,
  $buffers_send    = undef,
  $buffers_size    = undef,
  $max_lines_p_sec = undef,
  ### ADVANCED PARAMETERS ###
  $alias_val       = undef,
  $timeout         = undef,
  $allow_root      = undef,
  $include         = undef,
  ### USER-DEFINED MONITORED PARAMETERS ###
  $unsage_usr_par  = undef,
  $user_parameter  = undef,
  ### ADVANCED PARAMETERS ###
  $load_mod_path   = undef,
  $load_module     = undef,
) inherits zabbix {
    
  notice("#I zabbix::agent> [${server}]")
  
  if $server == undef {
    fail('#ERROR zabbix::agent> You must set zabbix server.')
  }

  # Configuration option 1
  if $opt_use_template == 'yes' and $agent_template != undef {
    $template = $agent_template
  }
  # Configuration option 2 and 3 [use default template]
  else {
    $template = 'zabbix/etc/zabbix/zabbix_agentd.conf.erb'
  }
  notice("#I zabbix::agent> Using template [${template}]")

  # Install package  
  include zabbix::user
  include zabbix::agent::package
  include zabbix::agent::service

  # Config & Start
  $zabbix_server = $server
  file { '/etc/zabbix/zabbix_agentd.conf':
    ensure  => present,
    content => template($template),
    mode    => '0644',
    require => Package[$agent_package],
    notify  => Service[$agent_service],
  }
  
  file {'/var/run/zabbix':
    ensure => 'directory',
    group  => 'zabbix',
    owner  => 'zabbix',
  }


  if $firewall_enabled == true {
    # Setup firewall rules
    if $::osfamily == 'redhat' and $::operatingsystemmajrelease == 7 {

      ensure_packages('iptables-services', {'ensure' => 'latest'})
      Package['iptables-services'] -> Firewall <| |>

      # Skip service management
      #service { 'zabbix-firewalld': enable => false, }
      #service { 'iptables':  enable => true, }
    }

    firewall { '001 allow Zabbix Agent conn':
      iniface => 'eth0',
      proto   => 'tcp',
      port    => $listen_port,
      state   => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
    }
  }
  if $::selinux_current_mode == 'enforcing' {
    warning("#WARN> SELINUX doesn't support Zabbix Agent on ")
    warning(" ${::selinux_current_mode} mode, please ensure \'permissive\'")
    warning(' mode or read DRAFT.md to fix it. ;)')
  }
}
