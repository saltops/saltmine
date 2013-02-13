#!mako|yaml

#openstack-keystone setup

include:
  - saltmine.services.repos.epel
  - saltmine.services.repos.percona
  - saltmine.services.repos.ius

<%
  saltmine_openstack_mysql_root_username=pillar['saltmine_openstack_mysql_root_username']
  saltmine_openstack_mysql_root_password=pillar['saltmine_openstack_mysql_root_password']
%>


# Enable the epel testing repo by default
# http://docs.saltstack.org/en/latest/ref/states/all/salt.states.file.html
epel-testing-enable:
  file.sed:
    - name: /etc/yum.repos.d/epel-testing.repo
    - before: 0
    - after: 1
    - limit: ^enabled=

#------------
# qpid
#------------

qpid-cpp-server-pkgs:
  pkg:
    - installed
    - names: 
      - qpid-cpp-server
     #- qpid-cpp-server-daemon
    - require:
      - pkg: epel-repo

qpid-authno-conf:
  file.sed:
    - name: /etc/qpidd.conf
    - before: 'yes'
    - after: 'no'
    - limit: ^auth=
    - require:
      - pkg: qpid-cpp-server-pkgs
    - watch_in:
      - service: qpid-service

avahi-pkg:
  pkg:
    - installed
    - name: avahi
    - require:
      - pkg: epel-repo

dhcp-control-pkg:
  pkg:
    - installed
    - name: dnsmasq-utils
    - require:
      - pkg: epel-repo

#----------------------------
# Begin nova-specific install
#----------------------------

openstack-nova-common-pkg:
  pkg:
    - installed
    - name: openstack-nova-common
    - require:
      - service: messagebus-service
      - pkg: dhcp-control-pkg

#for testing nova within a vm, need this:
openstack-nova-vm-on-vm:
  file.sed:
    - name: /etc/nova/nova.conf
    - before: 'kvm'
    - after: 'none'
    - limit: ^libvirt_type=
    - require:
      - pkg: openstack-nova-common-pkg


#----------------------------
# Install Packages
#----------------------------

openstack-cinder-pkg:
  pkg:
    - installed
    - name: openstack-cinder
    - require:
      - pkg: openstack-nova-common-pkg

openstack-swift-plugin-pkg:
  pkg:
    - installed
    - name: openstack-swift-plugin-swift3
    - require:
      - pkg: openstack-cinder-pkg

# http://docs.saltstack.org/en/latest/ref/states/highstate.html

openstack-pkgs:
  pkg.installed:
    - names:
      - openstack-swift-plugin-swift3
      - openstack-nova
      - qemu-kvm
      - qemu-img
      - qemu-kvm-tools 
      - memcached 
      - openstack-nova-novncproxy
      - openstack-glance 
      - openstack-keystone 
      - openstack-dashboard
      - openstack-swift
      - openstack-quantum
      - virt-what
      - openstack-utils
    - require:
      - pkg: openstack-swift-plugin-pkg
      - pkg: epel-repo

#only use localinstall for testing...
mysql-pkg:
  pkg.installed:
    - names: 
      - mysql55
      - mysql55-server
    - require: 
      - pkg: openstack-pkgs
      - pkg: ius-repo

#----------------------------
# Enable & Start Services
#----------------------------

qpid-service:
  service:
    - running
    - enable: True
    - name: qpidd
    - require:
      - pkg: qpid-cpp-server-pkgs

messagebus-service:
  service:
    - running
    - enable: True
    - name: messagebus
    - require:
      - pkg: dhcp-control-pkg

libvirtd-service:
  service:
    - running
    - enable: True
    - name: libvirtd
    - require:
      - pkg: openstack-pkgs

httpd-service:
  service:
    - running
    - enable: True
    - name: httpd
    - require:
      - pkg: openstack-pkgs

% for svc in ['api','registry']:
openstack-glance-${svc}-service:
  service:
    - running
    - enable: True
    - name: openstack-glance-${svc}
    - require:
      - pkg: openstack-pkgs
      - cmd: glance-db-init
% endfor

% for svc in ['api', 'objectstore', 'compute', 'network', 'scheduler', 'cert', 'consoleauth', 'novncproxy']:
openstack-nova-${svc}-service:
  service:
    - running
    - enable: True
    - name: openstack-nova-${svc}
    - require:
      - pkg: openstack-pkgs
      - service: mysql-service
      - cmd: nova-db-init
      - cmd: keystone-db-init
% endfor

openstack-keystone-service:
  service:
    - running
    - enable: True
    - name: openstack-keystone
    - require:
      - pkg: openstack-keystone

mysql-service:
  service:
    - name: mysql
    - running
    - enable: True
    - require:
      - pkg: mysql-pkg



#----------------------------
# Initialize DB's 
#----------------------------

nova-db-init:
  cmd.run:
    - name: "openstack-db -y --init --service nova --rootpw '${saltmine_openstack_mysql_root_password}'"
    - unless: echo '' | mysql nova
    - require:
      - pkg: openstack-pkgs
      - service: mysql-service

glance-db-init:
  cmd.run:
    - name: "openstack-db -y --init --service glance --rootpw '${saltmine_openstack_mysql_root_password}'"
    - unless: echo '' | mysql glance
    - require:
      - pkg: openstack-pkgs
      - service: mysql-service

keystone-db-init:
  cmd.run:
    - name: "openstack-db -y --init --service keystone --rootpw '${saltmine_openstack_mysql_root_password}'"
    - unless: echo '' | mysql keystone
    - require:
      - pkg: openstack-pkgs
      - service: mysql-service

#----------------------------
# Install Config Files
#----------------------------

cinder-init1:
  cmd.run:
    - name: openstack-config --set /etc/nova/nova.conf DEFAULT volume_api_class nova.volume.cinder.API
    - unless: grep 'nova.volume.cinder.API' /etc/nova/nova.conf
    - require:
      - pkg: openstack-cinder-pkg
      - pkg: openstack-pkgs
      - service: openstack-keystone
      # - service: openstack-nova-api
      # - service: openstack-nova-compute

cinder-init2:
  cmd.run:
    - name: 'openstack-config --set /etc/nova/nova.conf DEFAULT enabled_apis ec2,osapi_compute,metadata'
    - unless: "grep 'ec2,osapi_compute,metadata' /etc/nova/nova.conf"
    - require:
      - pkg: openstack-cinder-pkg
      - pkg: openstack-pkgs
      - service: openstack-keystone
      # - service: openstack-nova-api
      # - service: openstack-nova-compute