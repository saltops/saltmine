#!mako|yaml

# openstack-folsom networknode setup

include:
  - openstack-folsom.common.openstackcommon
  - openstack-folsom.common.quantum
  - openstack-folsom.common.openvswitch-bridges-networknode

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

quantum-dhcp-agent-service:
  service:
    - running
    - enable: True
    - name: quantum-dhcp-agent
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

openstack-quantum-l3_agent-ini:
  file.managed:
    - name: /etc/quantum/l3_agent.ini
    - source: salt://saltmine/files/openstack/l3_agent.ini
    - defaults:
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_auth_port: ${saltmine_openstack_keystone_auth_port}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
        saltmine_openstack_keystone_metadata_port: ${saltmine_openstack_keystone_metadata_port}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name} 
        saltmine_openstack_quantum_user: ${saltmine_openstack_quantum_user}
        saltmine_openstack_quantum_pass: ${saltmine_openstack_quantum_pass}
    - template: mako
    - require:
      - pkg: openstack-quantum-openvswitch-pkg
    - watch_in:
      - service: quantum-l3-agent-service

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

quantum-l3-agent-service:
  service:
    - running
    - enable: True
    - name: quantum-l3-agent
    - require:
      - pkg: openstack-quantum-openvswitch-pkg