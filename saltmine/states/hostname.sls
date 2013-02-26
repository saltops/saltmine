#!mako|yaml

<%
#hostname=''
hostname=pillar['saltmine_hostname']
%>

% if grains['os_family'] == 'RedHat':
hostname-file:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://saltmine/files/hostname/network-file
    - template: mako
    - defaults:
        hostname: ${hostname}
% endif

hostname-set-cmd:
  cmd.wait:
    - name: |
        hostname ${hostname}
    - watch:
      - file: hostname-file