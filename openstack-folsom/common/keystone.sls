#!mako|yaml

# openstack-folsom keystone setup

include:
  - saltmine.pkgs.epel
  - saltmine.pkgs.percona
  - saltmine.pkgs.ius

<%
  saltmine_openstack_mysql_root_username=pillar['saltmine_openstack_mysql_root_username']
  saltmine_openstack_mysql_root_password=pillar['saltmine_openstack_mysql_root_password']

  saltmine_openstack_keystone_user=pillar['saltmine_openstack_keystone_user']
  saltmine_openstack_keystone_pass=pillar['saltmine_openstack_keystone_pass']
  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']

  saltmine_openstack_keystone_service_token=pillar['saltmine_openstack_keystone_service_token']
  saltmine_openstack_keystone_service_endpoint=pillar['saltmine_openstack_keystone_service_endpoint']
  saltmine_openstack_keystone_service_tenant_name=pillar['saltmine_openstack_keystone_service_tenant_name']

  saltmine_openstack_OS_USERNAME=pillar['saltmine_openstack_OS_USERNAME']
  saltmine_openstack_OS_PASSWORD=pillar['saltmine_openstack_OS_PASSWORD']
  saltmine_openstack_OS_TENANT_NAME=pillar['saltmine_openstack_OS_TENANT_NAME']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']

%>

mysql-pkg:
  pkg.installed:
    - names: 
      - mysql55-server
    - require: 
      - pkg: ius-repo

python-mysqldb-pkg:
  pkg.installed:
    - names: 
      - MySQL-python
# on Ubuntu
#      - python-mysqldb
    - require: 
      - pkg: ius-repo
      - pkg: mysql-pkg

mysql-service:
  service:
    - name: mysqld
    - running
    - enable: True
    - require:
      - pkg: mysql-pkg

rabbitmq-server-pkg:
  pkg.installed:
    - names: 
      - rabbitmq-server
    - require: 
      - pkg: epel-repo

rabbitmq-server-service:
  service:
    - running
    - enable: True
    - names: 
      - rabbitmq-server
    - require: 
      - pkg: epel-repo

openstack-keystone-pkg:
  pkg.installed:
    - names:
      - openstack-keystone 
    - require:
      - pkg: epel-repo

keystone-db-create:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE keystone;"
    - unless: echo '' | mysql keystone
    - require:
      - pkg: mysql-pkg
      - pkg: openstack-keystone-pkg
    - watch_in:
      - cmd: keystone-db-init

keystone-db-init:
  cmd.run:
    - name: | 
        mysql -u root -e "GRANT ALL ON keystone.* TO '${saltmine_openstack_keystone_user}'@'%' IDENTIFIED BY '${saltmine_openstack_keystone_pass}';"
    - unless: |
        echo '' | mysql keystone -u ${saltmine_openstack_keystone_user} -h 0.0.0.0 --password=${saltmine_openstack_keystone_pass}

openstack-keystone-service:
  service:
    - running
    - enable: True
    - name: openstack-keystone
    - require:
      - pkg: openstack-keystone-pkg

keystone-conf:
  file.sed:
    - name: /etc/keystone/keystone.conf
    - before: |
        mysql:.*
    - after: | 
        mysql://${saltmine_openstack_keystone_user}:${saltmine_openstack_keystone_pass}@${saltmine_openstack_keystone_ip}/keystone
    - limit: ^connection\ =
    - require:
      - pkg: openstack-keystone-pkg
    - watch_in:
      - service: openstack-keystone-service

keystone-db-sync:
  cmd.wait:
    - name: keystone-manage db_sync
    - watch:
      - cmd: keystone-db-init
      - cmd: keystone-db-create
      - file: keystone-conf

keystone-basic-script:
  file.managed:
    - name: /root/keystone-basic.sh
    - source: salt://saltmine/files/openstack/keystone-basic.sh
    - template: mako
    - defaults:
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_OS_PASSWORD: ${saltmine_openstack_OS_PASSWORD}
        saltmine_openstack_OS_TENANT_NAME: ${saltmine_openstack_OS_TENANT_NAME}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name}
    - require:
      - service: openstack-keystone-service
  cmd.wait:
    - name: sh /root/keystone-basic.sh
    - watch:
      - cmd: keystone-db-sync

keystone-endpoints-script:
  file.managed:
    - name: /root/keystone-endpoints-basic.sh
    - source: salt://saltmine/files/openstack/keystone-endpoints-basic.sh
    - template: mako
    - defaults:
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
        saltmine_openstack_keystone_user: ${saltmine_openstack_keystone_user}
        saltmine_openstack_keystone_pass: ${saltmine_openstack_keystone_pass}
    - require:
      - service: openstack-keystone-service
  cmd.wait:
    - name: sh /root/keystone-endpoints-basic.sh
    - watch:
      - cmd: keystone-basic-script

keystone-creds-script:
  file.managed:
    - name: /root/keystonerc
    - source: salt://saltmine/files/openstack/keystonerc
    - template: mako
    - defaults:
        saltmine_openstack_OS_USERNAME: ${saltmine_openstack_OS_USERNAME}
        saltmine_openstack_OS_PASSWORD: ${saltmine_openstack_OS_PASSWORD}
        saltmine_openstack_OS_TENANT_NAME: ${saltmine_openstack_OS_TENANT_NAME}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
    - require:
      - service: openstack-keystone-service
  cmd.wait:
    - name: source /root/keystonerc
    - watch:
      - cmd: keystone-endpoints-script