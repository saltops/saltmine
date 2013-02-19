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

  saltmine_openstack_glance_user=pillar['saltmine_openstack_glance_user']
  saltmine_openstack_glance_pass=pillar['saltmine_openstack_glance_pass']
  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']

  saltmine_openstack_keystone_service_token=pillar['saltmine_openstack_keystone_service_token']
  saltmine_openstack_keystone_service_endpoint=pillar['saltmine_openstack_keystone_service_endpoint']
  saltmine_openstack_keystone_service_tenant_name=pillar['saltmine_openstack_keystone_service_tenant_name']

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
      - pkg: openstack-quantum-pkg
      - cmd: openvswitch-download-tarball