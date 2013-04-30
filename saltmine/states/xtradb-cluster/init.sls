#!mako|yaml

# Based on this, but modified to work with Ubuntu 12.04:
# http://www.percona.com/doc/percona-xtradb-cluster/howtos/3nodesec2.html

<%
  xtradb_nodes = pillar['saltmine_xtradb_nodes']
%>

include:
  - saltmine.services.xtradb-server

mnt-data-dir:
  file.directory:
    - name: /mnt/data
    - user: mysql
    - makedirs: True
    - require:
      - pkg: percona-xtradb-pkgs

mnt-data-dir-init:
  cmd.run:
    - name: mysql_install_db --datadir=/mnt/data --user=mysql
    - unless: [ -z '$(ls /mnt/data/)'] || echo 'NOT EMPTY'
    - require:
      - file: mnt-data-dir

# Retrieving from pillars and putting into this format:
# expected xtradb_nodes pillar format:
# xtradb_nodes={'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103'}

% for xtradb_node in xtradb_nodes:
xtradb-my-cnf-nodes${xtradb_node[0]}:
  file.managed
    - name: /etc/my.cnf
    - source: salt://saltmine/files/xtradb-cluster/my.cnf.mako
    - template: mako
    - require:
      - pkg: percona-xtradb-pkgs
    - defaults:
        current_node: ${xtradb_node[0]}
        mysql_nodes: ${xtradb_nodes}
% endfor