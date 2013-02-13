#!mako|yaml

#openstack-keystone setup

include:
  - saltmine.services.repos.epel
  - saltmine.services.repos.percona

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

openstack-utils-pkg:
  pkg:
    - installed
    - name: openstack-utils
    - require:
      - pkg: epel-repo

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

qpid-service:
  service:
    - running
    - enable: True
    - name: qpidd


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

messagebus-service:
  service:
    - running
    - enable: True
    - name: messagebus
    - require:
      - pkg: dhcp-control-pkg

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
# Enable & Start Services
#----------------------------

% for svc in ['api','registry']:
openstack-glance-${svc}-service:
  service:
    - running
    - enable: True
    - name: openstack-glance-${svc}
    - require:
      - pkg: openstack-pkgs
% endfor

% for svc in ['api', 'objectstore', 'compute', 'network', 'scheduler', 'cert', 'consoleauth', 'novncproxy']:
openstack-nova-${svc}-service:
  service:
    - running
    - enable: True
    - name: openstack-nova-${svc}
    - require:
      - pkg: openstack-pkgs
% endfor

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
    - require:
      - pkg: openstack-swift-plugin-pkg

#only use localinstall for testing...
openstack-local-mysql:
  pkg.installed:
    - names: 
      - Percona-Server-client-55 
      - Percona-Server-server-55
    - require: 
      - pkg: openstack-pkgs
      - pkg: percona-repo

openstack-local-mysql-service:
  service:
    - name: mysql
    - running
    - enable: True
    - require:
      - pkg: openstack-local-mysql

openstack-local-mysql-init-script:
  file.managed:
    - name: /root/mysql-init.sh
    - source: salt://saltmine/services/openstack-keystone/openstack-local-mysql-init.sh
    - template: mako
    - require:
      - service: openstack-local-mysql-service
    - defaults:
        saltmine_openstack_mysql_root_username: ${saltmine_openstack_mysql_root_username}
        saltmine_openstack_mysql_root_password: ${saltmine_openstack_mysql_root_password}

openstack-local-mysql-init:
  cmd.run:
    - name: sh /root/mysql-init.sh
    - unless: mysql -u root
    - require:
      - file: openstack-local-mysql-init-script
    - watch_in:
      - file: openstack-local-mysql-service
    - stateful: True      
