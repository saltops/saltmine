#!mako|yaml

<%
hostname=pillar['saltmine_hostname']
%>

# Using the pillar setting 'saltmine_hostname', which 
# defaults to the minion id, this sets the hostname on boot, 
# sets the hostname currently w/o reboot, and adds the hostname
# to the hosts file so that minions can ping themselves.

# This does NOT set the fqdn, but if the fqdn is not explicitly set,
# many daemons use the hostname as the fqdn.

#---------------------------------
# Permanently set hostname on boot
#---------------------------------

% if grains['os_family'] == 'RedHat':
hostname-file:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://saltmine/files/hostname/network-file
    - template: mako
    - defaults:
        hostname: ${hostname}
    - watch_in:
      - cmd: hostname-set-cmd
% endif

% if grains['os_family'] == 'Debian':
hostname-file:
  file.managed:
    - name: /etc/hostname
    - source: salt://saltmine/files/hostname/hostname-file
    - template: mako
    - defaults:
        hostname: ${hostname}
    - watch_in:
      - cmd: hostname-set-cmd
% endif

#---------------------------
# Set hostname w/o reboot
#---------------------------

# set the hostname manually so the hostname setting takes affect before reboot.
hostname-set-cmd:
  cmd.wait:
    - name: |
        hostname ${hostname}


#---------------------------
# Add hostname to hosts file
#---------------------------

# Note: Using the 127.0.1.1 entry. This should work fine on most linuxes.
# http://serverfault.com/questions/363095/what-does-127-0-1-1-represent-in-etc-hosts

# create 127.0.1.1 entry in /etc/hosts file if it doesn't already exist
hostname-127-0-1-1-create:
  cmd.run:
    - name: |
        echo '127.0.1.1   ADD_HOSTNAME_HERE' >> /etc/hosts
    - unless: |
        [[ `cat /etc/hosts | grep '^127.0.1.1' | wc -l` == '1' ]] && echo '127.0.1.1 loopback exists'

# add current hostname if the 127.0.1.1 interface doesn't already include it. 
# this assumes that the 127.0.1.1 interface is reserved for setting the hostname.
hostname-add-hostname:
  cmd.run:
    - name: |
        sed s/127\.0\.1\.1.*/127\.0\.1\.1\ \ \ ${hostname}/ /etc/hosts > /tmp/hosts.new && cp -f /tmp/hosts.new /etc/hosts
    - unless: |
        grep '^127\.0\.1\.1\ \ \ ${hostname}$' /etc/hosts && echo 'hostname exists'
    - require:
      - cmd: hostname-127-0-1-1-create