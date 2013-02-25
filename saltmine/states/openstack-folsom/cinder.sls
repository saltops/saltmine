#!mako|yaml

# openstack-folsom cinder setup

<%
  saltmine_openstack_cinder_user=pillar['saltmine_openstack_cinder_user']
  saltmine_openstack_cinder_pass=pillar['saltmine_openstack_cinder_pass']

  saltmine_openstack_keystone_service_token=pillar['saltmine_openstack_keystone_service_token']
  saltmine_openstack_keystone_service_endpoint=pillar['saltmine_openstack_keystone_service_endpoint']
  saltmine_openstack_keystone_service_tenant_name=pillar['saltmine_openstack_keystone_service_tenant_name']
  saltmine_openstack_keystone_auth_port=pillar['saltmine_openstack_keystone_auth_port']
  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']

  saltmine_openstack_quantum_user=pillar['saltmine_openstack_quantum_user']
  saltmine_openstack_quantum_pass=pillar['saltmine_openstack_quantum_pass']

%>

#----------------------------
# Init db's
#----------------------------

% if 'openstack-control' in grains['roles']:

openstack-cinder-db-create:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE cinder;"
    - unless: echo '' | mysql cinder
    - require:
      - pkg: mysql-pkg
      - pkg: openstack-nova-server-pkg
    - watch_in:
      - cmd: openstack-cinder-db-init

openstack-cinder-db-init:
  cmd.run:
    - name: |
        mysql -u root -e "GRANT ALL ON cinder.* TO '${saltmine_openstack_cinder_user}'@'%' IDENTIFIED BY '${saltmine_openstack_cinder_pass}';"
    - unless: |
        echo '' | mysql cinder -u ${saltmine_openstack_cinder_user} -h 0.0.0.0 --password=${saltmine_openstack_cinder_pass}

openstack-cinder-db-sync:
  cmd.wait:
    - name: cinder-manage db sync
    - watch:
      - cmd: openstack-cinder-db-init
      - cmd: openstack-cinder-db-create

% endif

#----------------------------
# Install Packages
#----------------------------

cinder-pkgs:
  pkg.installed:
    - names:
      - openstack-cinder
      - python-cinderclient
      - python-cinder
      - iscsi-initiator-utils
      - scsi-target-utils
      - sg3_utils
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

#----------------------------
# Manage config files
#----------------------------

% if 'openstack-compute' in grains['roles']:

openstack-cinder-api-paste-ini:
  file.managed:
    - name: /etc/cinder/api-paste.ini
    - source: salt://saltmine/files/openstack/cinder-api-paste.ini
    - defaults:
        saltmine_openstack_cinder_user: ${saltmine_openstack_cinder_user}
        saltmine_openstack_cinder_pass: ${saltmine_openstack_cinder_pass}
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name}
        saltmine_openstack_keystone_auth_port: ${saltmine_openstack_keystone_auth_port}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
        saltmine_openstack_quantum_user: ${saltmine_openstack_quantum_user}
        saltmine_openstack_quantum_pass: ${saltmine_openstack_quantum_pass}
    - template: mako
    - require:
      - pkg: cinder-pkgs
    - watch_in:
      - service: openstack-cinder-service

openstack-cinder-conf:
  file.managed:
    - name: /etc/cinder/cinder.conf
    - source: salt://saltmine/files/openstack/cinder.conf
    - defaults:
        saltmine_openstack_cinder_user: ${saltmine_openstack_cinder_user}
        saltmine_openstack_cinder_pass: ${saltmine_openstack_cinder_pass}
        saltmine_openstack_keystone_ip: ${saltmine_openstack_keystone_ip}
        saltmine_openstack_keystone_service_tenant_name: ${saltmine_openstack_keystone_service_tenant_name}
        saltmine_openstack_keystone_auth_port: ${saltmine_openstack_keystone_auth_port}
        saltmine_openstack_keystone_ext_ip: ${saltmine_openstack_keystone_ext_ip}
        saltmine_openstack_quantum_user: ${saltmine_openstack_quantum_user}
        saltmine_openstack_quantum_pass: ${saltmine_openstack_quantum_pass}
    - template: mako
    - require:
      - pkg: cinder-pkgs

#----------------------------
# Init services
#----------------------------

openstack-cinder-service:
  service:
    - running
    - enable: True
    - names:
  % for svc in ['api', 'scheduler','volume']:
      - openstack-cinder-${svc}
  % endfor
    - require:
      - pkg: cinder-pkgs
    - watch:
      - file: openstack-cinder-conf
      - file: openstack-cinder-api-paste-ini


#----------------------------
# Create Volumegroup
#----------------------------

# dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=2G
# losetup /dev/loop2 cinder-volumes
# fdisk /dev/loop2
# #Type in the followings:
# n
# p
# 1
# ENTER
# ENTER
# t
# 8e
# w
# Proceed to create the physical volume then the volume group:

# pvcreate /dev/loop2
# vgcreate cinder-volumes /dev/loop2

% endif
