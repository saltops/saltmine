#!mako|yaml

# Yes, they will b running on centos. this won't work on debian.
# http://www.percona.com/doc/percona-xtradb-cluster/howtos/3nodesec2.html

<%
  server_status = pillar.get('server_status')
%>

include:
  - common.services.repos.percona


percona-xtradb-client-pkg:
  pkg:
    - installed
    - name: Percona-XtraDB-Cluster-client
    - require:
      - pkg: repos-percona

percona-xtradb-server-pkg:
  pkg:
    - installed
    - name: Percona-XtraDB-Cluster-server
    - require:
      - pkg: repos-percona

mnt-data-dir:
  file.directory:
    - name: /mnt/data
    - user: mysql
    - makedirs: True
    - require:
      - pkg: percona-xtradb-client-pkg
      - pkg: percona-xtradb-server-pkg

mnt-data-dir-init:
  cmd.run:
    - name: mysql_install_db --datadir=/mnt/data --user=mysql
    - unless: [ -z "$(ls /mnt/data/)"] || echo 'NOT EMPTY'
    - require:
      - file: mnt-data-dir

percona-xtradb-client:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/my.cnf
    - require:
      - pkg: percona-xtradb-client-pkg

percona-xtradb-server:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/my.cnf
    - require:
      - pkg: percona-xtradb-server-pkg
      - cmd: mnt-data-dir-init

# Retrieving from pillars and putting into this format:
# xtradb_nodes={'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103'}

<%
if server_status:
  xtradb_nodes={}
  for server in server_status:
    if server_status[server]['roles'] == 'xtradb' and server_status[server]['state'] != 'TERMINATED':
      node_number = server.split('-')[-1]
      dns = server_status[server]['private_dns']
      xtradb_nodes.update({node_number:dns})
%>

% if server_status:
  % for server in server_status:
    % if server_status[server]['roles'] == 'xtradb' and server_status[server]['state'] != 'TERMINATED':
<% 
xtradb_node_num = server.split('-')[-1]  # Example: openstack-xtradb-1
%>

xtradb-my-cnf-nodes${xtradb_node_num}:
  file.managed
    - name: /etc/my.cnf
    - source: salt://common/services/xtradb-cluster/my.cnf.mako
    - template: mako
    - require:
      - pkg: percona-xtradb-client-pkg
      - pkg: percona-xtradb-server-pkg
    - defaults:
      current_node: ${xtradb_node_num}
      mysql_nodes: ${xtradb_nodes} 
    % endif
  % endfor
% endif