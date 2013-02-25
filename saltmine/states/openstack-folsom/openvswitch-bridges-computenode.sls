#!mako|yaml

openstack-openvswitch-service:
  service:
    - running
    - enable: True
    - name: openvswitch
    - require:
      - pkg: openstack-quantum-openvswitch-pkg

openstack-networknode-br-int-bridge:
  cmd.run:
    - name: ovs-vsctl add-br br-int
    - unless: ovs-vsctl list-br | grep 'br-int'
    - require:
      - service: openstack-openvswitch-service

openstack-networknode-br-eth1-bridge:
  cmd.run:
    - name: ovs-vsctl add-br br-eth1
    - unless: ovs-vsctl list-br | grep 'br-eth1'
    - require:
      - service: openstack-openvswitch-service

% for env in ['eth1']:
openstack-networknode-br-eth1-port:
  cmd.run:
    - name: ovs-vsctl add-port br-eth1 ${env}
    - unless: |
        [[ `ovs-vsctl list-ports br-eth1 2> /dev/null | grep '^${env}$'` == '${env}' ]] && echo '${env} port exists'
    - require:
      - service: openstack-openvswitch-service
      - cmd: openstack-networknode-br-eth1-bridge
% endfor