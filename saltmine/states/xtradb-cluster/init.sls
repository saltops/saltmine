#!mako|yaml

# Based on this, but modified to work with Ubuntu 12.04:
# http://www.percona.com/doc/percona-xtradb-cluster/howtos/3nodesec2.html

<%
  xtradb_nodes = pillar['saltmine_xtradb_nodes']
  xtradb_cluster_name = pillar['saltmine_xtradb_cluster_name']
%>

include:
  - saltmine.services.xtradb-server

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
