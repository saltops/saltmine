<%
#http://www.percona.com/doc/percona-xtradb-cluster/installation.html
# mysql_nodes={'1':'10.10.10.101', '2':'10.10.10.102', '3':'10.10.10.103'}
# wsrep_urls=gcomm://10.93.46.58:4567,gcomm://10.93.46.59:4567,gcomm://10.93.46.60:4567

node_count = len(mysql_nodes)

for x,y in enumerate(mysql_nodes):
  wsrep_urlstring+='gcomm://'+mysql_nodes[i]
  if node_count > x + 1:
    wsrep_urlstring+=','
%>
[mysqld_safe]
wsrep_urls=${wsrep_urlstring}

[mysqld]
datadir=/mnt/data
user=mysql

binlog_format=ROW

wsrep_provider=/usr/lib64/libgalera_smm.so

wsrep_slave_threads=2
wsrep_cluster_name=trimethylxanthine
wsrep_sst_method=rsync
wsrep_node_name=node${current_node}

innodb_locks_unsafe_for_binlog=1
innodb_autoinc_lock_mode=2