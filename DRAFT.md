# ROADMAP

## Feature: Zabbix Agent - Selinux

Creating the policy to allow SELINUX agent.

Create the policy file:

```
# cd /usr/share/selinux/devel
# cat > zabbix-fix.te
policy_module(zabbix-fix, 1.0)
require{
 type zabbix_agent_t;
 type zabbix_t;
 type ping_t;
 type zabbix_tmp_t;
}

allow ping_t zabbix_tmp_t:file read_file_perms;
allow ping_t zabbix_t:tcp_socket { read write };

kernel_read_network_state(zabbix_agent_t)
domain_read_all_domains_state(zabbix_agent_t)
dev_read_sysfs(zabbix_agent_t)
corenet_tcp_connect_all_ports(zabbix_agent_t)
```

Then, build the policy:
```
# make zabbix-fix.pp
Compiling targeted zabbix-fix module
/usr/bin/checkmodule:  loading policy configuration from tmp/zabbix-fix.tmp
/usr/bin/checkmodule:  policy configuration loaded
/usr/bin/checkmodule:  writing binary representation (version 10) to tmp/zabbix-fix.mod
Creating targeted zabbix-fix.pp policy package
rm tmp/zabbix-fix.mod tmp/zabbix-fix.mod.fc
```

Then, install the policy:
```
# semodule -i zabbix-fix.pp
```
Then verify it's installed:
```
# semodule -l | grep zabbix-fix
zabbix-fix	1.0
```

After installing the module, you can disable it:
```
# semodule -d zabbix-fix
```

Or enable it:
```
# semodule -e zabbix-fix
```

FONTE:
* https://support.zabbix.com/browse/ZBX-7607

