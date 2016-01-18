# zabbix

#### Table of Contents

1. [Overview](#1-overview)
2. [Module Description](#2-module-description)
3. [Setup](#3-setup)
    * [What module affects](#what-module-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning](#beginning)
4. [Usage](#4-usage)
5. [Limitations](#5-limitations)
6. [Development](#6-development)
6. [Release Notes](#7-release-notes)


## 1. Overview

This module can install and configure zabbix agent [ and the server in future ]

## 2. Module Description

Module to manage Zabbix Agent.


## 3. Setup

 See [Usage](#4-usage)

### What module affects

* This module module will set the zabbix repository [2.4] and install the latest version of agent

### Setup Requirements 


### Beginning 

This is a great module to configure your Zabbix agent. 

## 4. Usage

You have three ways to usage the class 

1. Using default template

```
class { 'zabbix::agent': 
	opt_use_template => 'yes',
	server 		 => 'your.zabbix.server',
}
```

2. Using custom template
```
class { 'zabbix::agent': 
	opt_use_template => 'yes',
	server 		 => 'your.zabbix.server',
	agent_template   => 'path/to/your/template.erb',
}
```

3. Using custom configuration
```
class { 'zabbix::agent': 
	opt_use_template => 'no',
	server		 => 'your.zabbix.server',
	listen_port      => "$::ipaddress",
	listen_ip        => '10050',
	start_agents     => '2',
	server_active    => 'your.zabbix.server',
	buffers_send     => '10',
	buffers_size     => '512',
}
```

## 5. Limitations

OS compatibility [tested]: 
* Red Hat family 7+ 

We're working to support more OS.

## 6. Development

See project page at :
* Github: https://github.com/mtulio/puppet-mod-zabbix
* Puppet forge: https://forge.puppetlabs.com/mtulio/zabbix

## 7. Release Notes

[1.0.3] 
* Review puppet code style and inheritance
* Review Documentation

[1.0.2]
* Fix inheritance
* Review puppet code style

[1.0.1]
* Fix default env names

[1.0.0]
* Add zabbix agent configuration

