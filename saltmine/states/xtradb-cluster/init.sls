#!mako|yaml

# Based on this, but modified to work with Ubuntu 12.04:
# http://www.percona.com/doc/percona-xtradb-cluster/howtos/3nodesec2.html

<%
  xtradb_nodes = pillar['saltmine_xtradb_nodes']
  xtradb_cluster_name = pillar['saltmine_xtradb_cluster_name']
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
    - unless: |
        [ -z '$(ls /mnt/data/)' ] || echo 'NOT EMPTY'
    - require:
      - file: mnt-data-dir
    - require_in:
      - file: my-cnf-xtradb-cluster

# this is simplified by us having the grains['id'] set to the system dns.
# expected xtradb_nodes pillar format:
# xtradb_nodes={'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103'}

my-cnf-xtradb-cluster:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://saltmine/files/xtradb-cluster/my.cnf.mako
    - template: mako
    - require:
      - pkg: percona-xtradb-pkgs
    - watch_in:
      - service: percona-xtradb-server
    - defaults:
        current_node: ${grains['id']}
        xtradb_nodes: ${xtradb_nodes}
        xtradb_cluster_name: ${xtradb_cluster_name}