#!yaml

## Global pillars for saltmine examples

saltmine_message_do_not_modify: 'This file is managed by Salt. Do Not Modify.'
saltmine_crontab_path: 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
saltmine_crontab_file_root: '/root/crontab_file_root'

## App Version Settings
saltmine_boto_version: '2.7.0'


## OpenStack settings
saltmine_openstack_mysql_root_username: 'root'
saltmine_openstack_mysql_root_password: 'test'

# Keystone
saltmine_openstack_keystone_user: 'keystone'
saltmine_openstack_keystone_pass: 'key2013'
saltmine_openstack_keystone_service_token: 27af01e78eaa2f9ee947
saltmine_openstack_keystone_admin_token: 27af01e78eaa2f9ee947
saltmine_openstack_keystone_service_tenant_name: 'service'
saltmine_openstack_keystone_service_endpoint: 'http://127.0.0.1:35357/v2.0'

saltmine_openstack_keystone_ip: '100.10.10.51'
saltmine_openstack_keystone_ext_ip: '192.168.100.51'

saltmine_openstack_OS_USERNAME: 'admin'
saltmine_openstack_OS_PASSWORD: '1234'
saltmine_openstack_OS_TENANT_NAME: 'admin'

# Glance
saltmine_openstack_glance_user: 'glance'
saltmine_openstack_glance_pass: 'gla2013'