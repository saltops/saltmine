#!mako|yaml

#openstack-keystone setup

include:
  - saltmine.pkgs.epel

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

qpid-cpp-server-pkgs:
  pkg:
    - installed
    - names: 
      - qpid-cpp-server
      - qpid-cpp-server-daemon
    - require:
      - pkg: epel-repo

avahi-pkg:
  pkg:
    - installed
    - name: avahi
    - require:
      - pkg: epel-repo

qpid-auth-no:
  file.sed:
    - name: /etc/qpidd.conf
    - before: yes
    - after: no
    - limit: ^auth=

dhcp-control-pkg:
  pkg:
    - installed
    - name: dnsmasq-utils
    - require:
      - pkg: repos-epel

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
    - watch:
      - file: /etc/nova/nova.conf


#for testing nova within a vm, need this:
openstack-nova-vm-on-vm:
  file.sed:
    - name: /etc/nova/nova.conf
    - before: kvm
    - after: none
    - limit: ^libvirt_type=
    - require:
      - pkg: openstack-nova-common-pkg

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
    - name: mysql
    - require: 
      - pkg: openstack-pkgs

openstack-local-mysql-service:
  service:
    - name: mysql
    - running
    - enable: True
    - require:
      - pkg: openstack-local-mysql

openstack-local-mysql-init:
  cmd.run:
    - name: df -h
    - unless: mysql -u root
    - require:
      - file: mnt-data-dir
    - stateful: true      
