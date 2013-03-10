#!mako|yaml

# openstack-folsom networknode setup

include:
  - openstack-folsom.common.openstackcommon
  - openstack-folsom.common.quantum
  - openstack-folsom.common.openvswitch-bridges-computenode
  - openstack-folsom.common.nova-compute
  - openstack-folsom.common.cinder

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

  saltmine_openstack_nova_user=pillar['saltmine_openstack_nova_user']
  saltmine_openstack_nova_pass=pillar['saltmine_openstack_nova_pass']

  saltmine_openstack_OS_USERNAME=pillar['saltmine_openstack_OS_USERNAME']
  saltmine_openstack_OS_PASSWORD=pillar['saltmine_openstack_OS_PASSWORD']
  saltmine_openstack_OS_TENANT_NAME=pillar['saltmine_openstack_OS_TENANT_NAME']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']
  saltmine_openstack_keystone_metadata_port=pillar['saltmine_openstack_keystone_metadata_port']
%>

openstack-quantum-service:
  service:
    - dead
    - enable: False
    - name: quantum-server
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

quantum-openvswitch-agent-service:
  service:
    - running
    - enable: True
    - name: quantum-openvswitch-agent
    - require:
      - pkg: openstack-quantum-openvswitch-pkg
    - watch:
      - file: openstack-quantum-ovs_quantum_plugin-ini

openstack-nova-compute-service:
  service:
    - running
    - enable: True
    - name: openstack-nova-compute
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

openstack-quantum-conf:
  file.managed:
    - name: /etc/quantum/quantum.conf
    - source: salt://saltmine/files/openstack/quantum.conf
    - defaults:
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
    - template: mako
    - require:
      - pkg: openstack-quantum-openvswitch-pkg
    - watch_in:
      - service: quantum-openvswitch-agent-service


#----------------------------
# Setup Nova for Compute
#----------------------------

openstack-nova-api-paste-ini:
  file.managed:
    - name: /etc/nova/api-paste.ini
    - source: salt://saltmine/files/openstack/nova-api-paste.ini
    - defaults:
        saltmine_openstack_nova_user: ${saltmine_openstack_nova_user}
        saltmine_openstack_nova_pass: ${saltmine_openstack_nova_pass}
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name}
        saltmine_openstack_keystone_auth_port: ${saltmine_openstack_keystone_auth_port}
    - template: mako
    - require:
      - pkg: openstack-quantum-openvswitch-pkg
    - watch_in:
      - service: openstack-nova-compute-service

openstack-nova-conf:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://saltmine/files/openstack/nova.conf
    - defaults:
        saltmine_openstack_nova_user: ${saltmine_openstack_nova_user}
        saltmine_openstack_nova_pass: ${saltmine_openstack_nova_pass}
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name}
        saltmine_openstack_keystone_auth_port: ${saltmine_openstack_keystone_auth_port}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
        saltmine_openstack_quantum_user: ${saltmine_openstack_quantum_user}
        saltmine_openstack_quantum_pass: ${saltmine_openstack_quantum_pass}
    - template: mako
    - require:
      - pkg: openstack-quantum-openvswitch-pkg
    - watch_in:
      - service: openstack-nova-compute-service

