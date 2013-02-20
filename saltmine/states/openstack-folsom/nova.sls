#!mako|yaml

# openstack-folsom nova setup

include:
  - saltmine.pkgs.epel
  - saltmine.pkgs.percona
  - saltmine.pkgs.ius

<%
  saltmine_openstack_mysql_root_username=pillar['saltmine_openstack_mysql_root_username']
  saltmine_openstack_mysql_root_password=pillar['saltmine_openstack_mysql_root_password']

  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']
  saltmine_openstack_keystone_service_token=pillar['saltmine_openstack_keystone_service_token']
  saltmine_openstack_keystone_service_endpoint=pillar['saltmine_openstack_keystone_service_endpoint']
  saltmine_openstack_keystone_service_tenant_name=pillar['saltmine_openstack_keystone_service_tenant_name']

  saltmine_openstack_glance_user=pillar['saltmine_openstack_glance_user']
  saltmine_openstack_glance_pass=pillar['saltmine_openstack_glance_pass']

  saltmine_openstack_quantum_user=pillar['saltmine_openstack_quantum_user']
  saltmine_openstack_quantum_pass=pillar['saltmine_openstack_quantum_pass']

  saltmine_openstack_nova_user=pillar['saltmine_openstack_nova_user']
  saltmine_openstack_nova_pass=pillar['saltmine_openstack_nova_pass']

  saltmine_openstack_OS_USERNAME=pillar['saltmine_openstack_OS_USERNAME']
  saltmine_openstack_OS_PASSWORD=pillar['saltmine_openstack_OS_PASSWORD']
  saltmine_openstack_OS_TENANT_NAME=pillar['saltmine_openstack_OS_TENANT_NAME']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']

%>

openstack-nova-pkg:
  pkg.installed:
    - names: 
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-console
      - openstack-nova-scheduler
      - openstack-nova-novnvproxy
      - novnc
    - require: 
      - pkg: epel-repo

openstack-nova-db-create:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE nova;"
    - unless: echo '' | mysql nova
    - require:
      - pkg: mysql-pkg
      - pkg: openstack-nova-pkg
    - watch_in:
      - cmd: openstack-nova-db-init

openstack-nova-db-init:
  cmd.run:
    - name: mysql -u root -e "GRANT ALL ON nova.* TO '${saltmine_openstack_nova_user}'@'%' IDENTIFIED BY '${saltmine_openstack_nova_pass}';"
    - unless: echo '' | mysql nova -u ${saltmine_openstack_nova_user} -h 0.0.0.0 --password=${saltmine_openstack_nova_pass}
