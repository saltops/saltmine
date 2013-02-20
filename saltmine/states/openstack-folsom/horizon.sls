#!mako|yaml

# openstack-folsom horizon setup

include:
  - saltmine.pkgs.epel
  - saltmine.pkgs.percona
  - saltmine.pkgs.ius

<%
  saltmine_openstack_mysql_root_username=pillar['saltmine_openstack_mysql_root_username']
  saltmine_openstack_mysql_root_password=pillar['saltmine_openstack_mysql_root_password']

  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']
  saltmine_openstack_keystone_auth_port=pillar['saltmine_openstack_keystone_auth_port']

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

openstack-dashboard-pkg:
  pkg.installed:
    - names: 
      - openstack-dashboard
    - require: 
      - pkg: epel-repo

memcached-pkg:
  pkg.installed:
    - names: 
      - memcached
    - require: 
      - pkg: epel-repo

memcached-service:
  service:
    - running
    - enable: True
    - name: memcached

openstack-dashboard-service:
  service:
    - running
    - enable: True
    - name: httpd
    - require:
      - pkg: openstack-dashboard-pkg

