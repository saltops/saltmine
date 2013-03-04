#!mako|yaml

#----------------------------
# Install Packages
#----------------------------

vm-pkgs:
  pkg.installed:
    - names:
      - avahi
      - libvirt
      - libvirt-devel
      - avahi
      - pm-utils
      - qemu-kvm
      - qemu-img
      - qemu-kvm-tools 
      - virt-what
      - openstack-nova-compute
      - python-cinderclient
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

#----------------------------
# Enable & Start Services
#----------------------------

messagebus-service:
  service:
    - running
    - enable: True
    - name: messagebus
    - require:
      - pkg: vm-pkgs

avahi-daemon-service:
  service:
    - running
    - enable: True
    - name: avahi-daemon
    - require:
      - service: messagebus-service

#http://quags.net/archives/53
libvirtd-service:
  service:
    - running
    - enable: True
    - name: libvirtd
    - require:
      - service: messagebus-service
      - service: avahi-daemon-service

#----------------------------
# Setup Virsh
#----------------------------

openstack-virsh-default-destroy:
  cmd.run:
    - name: virsh net-destroy default
    - unless: |
        virsh net-list 2>&1 | grep '^default' || echo 'default destroyed'
    - require:
      - service: libvirtd-service

openstack-virsh-default-undefine:
  cmd.run:
    - name: virsh net-undefine default
    - unless: |
        virsh net-undefine default 2>&1 | grep 'Network default has been undefined' && echo 'triggered' || echo 'default undefined'
    - require:
      - service: libvirtd-service
#      - cmd: openstack-virsh-default-destroy


#----------------------------
# Edit Files
#----------------------------

openstack-qemu-conf:
  file.managed:
    - name: /etc/libvirt/qemu.conf
    - source: salt://saltmine/files/openstack/qemu.conf
    - require:
      - pkg: vm-pkgs
    - watch_in:
      - service: libvirtd-service

openstack-libvirtd-conf:
  file.managed:
    - name: /etc/libvirt/libvirtd.conf
    - source: salt://saltmine/files/openstack/libvirtd.conf
    - require:
      - pkg: vm-pkgs
    - watch_in:
      - service: libvirtd-service

openstack-libvirtd-file:
  file.managed:
    - name: /etc/init.d/libvirtd
    - source: salt://saltmine/files/openstack/libvirtd
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: vm-pkgs
    - watch_in:
      - service: libvirtd-service