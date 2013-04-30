<%
#http://www.percona.com/doc/percona-xtradb-cluster/installation.html

## Variables (pass these in)
# current_node={'1':'node1.yourdomain.com', '2':'anothernode.yourdomain.com'}
# node_name='your_node_name'

if grains['os_family'] == 'RedHat':
  wsrep_provider='/usr/lib/libgalera_smm.so'
else:
  wsrep_provider='/usr/lib64/libgalera_smm.so'

node_count = len(xtradb_nodes)

wsrep_urlstring='gcomm://'

for x,y in enumerate(xtradb_nodes):
  wsrep_urlstring+=xtradb_nodes[y]
  if node_count > x + 1:
    wsrep_urlstring+=','
%>
[mysqld]
wsrep_cluster_address=${wsrep_urlstring}
# Node address
wsrep_node_address=${current_node}
wsrep_node_name=${current_node}

datadir=/mnt/data
user=mysql

binlog_format=ROW

wsrep_provider=/usr/lib/libgalera_smm.so

default_storage_engine=InnoDB
wsrep_slave_threads=2
wsrep_cluster_name=${xtradb_cluster_name}
wsrep_sst_method=rsync


innodb_locks_unsafe_for_binlog=1
innodb_autoinc_lock_mode=2