#!mako|yaml

# openstack-folsom controlnode setup

include:
  - openstack-folsom.common.openstackcommon
  - openstack-folsom.common.keystone
  - openstack-folsom.common.glance
  - openstack-folsom.common.quantum
  - openstack-folsom.common.horizon
  - openstack-folsom.common.nova
  - openstack-folsom.common.cinder