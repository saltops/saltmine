#!/bin/bash
#
echo "initializing openstack local mysql"
echo "UPDATE mysql.user SET password = password('${saltmine_openstack_mysql_root_password}') WHERE user = '${saltmine_openstack_mysql_root_username}'; DELETE FROM mysql.user WHERE user = ''; flush privileges;" | mysql -u root
# writing the state line
echo  # an empty line here so the next line will be the last.
echo "changed=yes" comment="set the mysql root password" whatever="123"