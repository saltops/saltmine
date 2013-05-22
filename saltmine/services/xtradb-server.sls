#!mako|yaml

include:
  - saltmine.pkgs.xtradb-cluster

percona-xtradb-server:
  service:
    - name: mysql
    - running
    - enable: 
      - True
    - require:
      - pkg: percona-xtradb-pkgs