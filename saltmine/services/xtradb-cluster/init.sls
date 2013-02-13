#!mako|yaml

# This won't work on debian currently.
# http://www.percona.com/doc/percona-xtradb-cluster/howtos/3nodesec2.html

<%
  xtradb_nodes = pillar['xtradb_nodes']
%>

include:
  - saltmine.services.repos.percona


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
# expected xtradb_nodes pillar format:
# xtradb_nodes={'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103'}

% for xtradb_node in xtrasb_nodes:
xtradb-my-cnf-nodes${xtradb_node[0]}:
  file.managed
    - name: /etc/my.cnf
    - source: salt://common/services/xtradb-cluster/my.cnf.mako
    - template: mako
    - require:
      - pkg: percona-xtradb-client-pkg
      - pkg: percona-xtradb-server-pkg
    - defaults:
      current_node: ${xtradb_node[0]}
      mysql_nodes: ${xtradb_nodes} 
% endfor