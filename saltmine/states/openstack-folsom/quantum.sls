#!mako|yaml

# openstack-folsom glance setup

include:
  - saltmine.pkgs.epel
  - saltmine.pkgs.percona
  - saltmine.pkgs.ius
  - saltmine.pkgs.openvswitch

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


  saltmine_openstack_OS_USERNAME=pillar['saltmine_openstack_OS_USERNAME']
  saltmine_openstack_OS_PASSWORD=pillar['saltmine_openstack_OS_PASSWORD']
  saltmine_openstack_OS_TENANT_NAME=pillar['saltmine_openstack_OS_TENANT_NAME']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']

%>


openstack-quantum-pkg:
  pkg.installed:
    - names: 
      - openstack-quantum
    - require: 
      - pkg: epel-repo

openstack-quantum-openvswitch-pkg:
  pkg.installed:
    - names: 
      - openstack-quantum-openvswitch
    - require: 
      - pkg: epel-repo

openstack-quantum-db-create:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE quantum;"
    - unless: echo '' | mysql quantum
    - require:
      - pkg: mysql-pkg
      - pkg: openstack-quantum-pkg
    - watch_in:
      - cmd: openstack-quantum-db-init

openstack-quantum-db-init:
  cmd.run:
    - name: mysql -u root -e "GRANT ALL ON quantum.* TO '${saltmine_openstack_quantum_user}'@'%' IDENTIFIED BY '${saltmine_openstack_quantum_pass}';"
    - unless: echo '' | mysql quantum -u ${saltmine_openstack_quantum_user} -h 0.0.0.0 --password=${saltmine_openstack_quantum_pass}


