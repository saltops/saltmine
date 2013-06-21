#!mako|yaml

#this installs the debiansys user so service mysql status works properly.

debian-cnf-xtradb-cluster:
  file.managed:
    - name: /etc/mysql/debian.cnf
    - source: salt://saltmine/files/xtradb-cluster/debian.cnf.mako
    - template: mako
    - defaults:
        saltmine_xtradbcluster_debiansys_password: ${pillar['saltmine_xtradbcluster_debiansys_password']}
        
debian-sys-maint-mysql-init:
  cmd.run:
    - name: GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '${pillar['saltmine_xtradbcluster_debiansys_password']}';
    - require:
      - file: debian-cnf-xtradb-cluster
