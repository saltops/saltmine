#!mako|yaml

## Global pillars for saltmine examples

saltmine_message_do_not_modify: 'This file is managed by Salt. Do Not Modify.'
saltmine_hostname: ${grains['id']}

## crontab settings
saltmine_crontab_path: 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
saltmine_crontab_file_root: '/root/crontab_file_root'

## App Version Settings
saltmine_boto_version:   '2.7.0'
saltmine_nodejs_version: '0.10.10'

## Tomcat7 Defaults
saltmine_tomcat7_webappsdir:  '/var/lib/tomcat7/webapps'
saltmine_tomcat7_homedir:     '/usr/share/tomcat7'

## xtradb settings
saltmine_xtradb_nodes:  {'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103', '4':'10.10.10.104'}
saltmine_xtradb_cluster_name: 'xtradb_cluster_one'
saltmine_xtradbcluster_debiansys_password: 's00persecurepassword'

## rsyslog settings
saltmine_rsyslog_server_address: '192.168.1.1'
