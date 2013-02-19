#!mako|yaml

# openstack-folsom keystone setup

include:
  - saltmine.states.openstack-folsom.keystone
  - saltmine.states.openstack-folsom.glance
  - saltmine.states.openstack-folsom.quantum
