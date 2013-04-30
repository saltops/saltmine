#!mako|yaml

include:
  - saltmine.pkgs.xtradb-cluster

percona-xtradb-server:
  service:
    - name: mysql
    - running
    - enable: True
    - watch:
      - file: /etc/my.cnf
    - require:
      - pkg: percona-xtradb-pkgs