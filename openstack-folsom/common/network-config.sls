#!mako|yaml

% if ('openstack-control' in grains['roles']) and ('localdev' in grains['environment']):

# NAT should be preconfigured otherwise can copy the following ...
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
# auto lo
# iface lo inet loopback

# # The primary network interface - Virtual Box NAT connection
# auto eth2
# iface eth2 inet dhcp

# # Virtual Box vboxnet0 - Openstack Management Network
# auto eth0
# iface eth0 inet static
# address 100.10.10.51
# netmask 255.255.255.0
# gateway 100.10.10.1

# # Virtual Box vboxnet2 - for exposing Openstack API over external network
# auto eth1
# iface eth1 inet static
# address 192.168.100.51
# netmask 255.255.255.0
# gateway 192.168.100.1

# system:
#   network.system:
#     - enabled: True
#     - hostname: openstack-control

eth0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 100.10.10.51
    - netmask: 255.255.255.0
    - gateway: 100.10.10.1

eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.100.51
    - netmask: 255.255.255.0
    - gateway: 192.168.100.1

eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: dhcp


# eth0      Link encap:Ethernet  HWaddr 08:00:27:1D:A1:FE  
#           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fe1d:a1fe/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:33083 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:23912 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000 
#           RX bytes:13602517 (12.9 MiB)  TX bytes:3204268 (3.0 MiB)

# eth1      Link encap:Ethernet  HWaddr 08:00:27:1E:CA:81  
#           inet addr:100.10.10.51  Bcast:100.10.10.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fe1e:ca81/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:242 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:212 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000 
#           RX bytes:100024 (97.6 KiB)  TX bytes:23675 (23.1 KiB)

# eth2      Link encap:Ethernet  HWaddr 08:00:27:F6:AD:01  
#           inet addr:192.168.100.51  Bcast:192.168.100.255  Mask:255.255.255.0
#           inet6 addr: fe80::a00:27ff:fef6:ad01/64 Scope:Link
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:33 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:14 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000 
# eth2:
#   network.managed:
#     - enabled: True
#     - type: eth
#     - proto: none
#     - ipaddr: 10.0.2.15
#     - netmask: 255.255.255.0
#     - gateway: 10.0.2.1

# eth3:
#   network.managed:
#     - enabled: False
#     - type: eth
#     - proto: none

% endif
