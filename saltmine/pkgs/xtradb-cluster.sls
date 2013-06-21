#!mako|yaml

include:
  - saltmine.pkgs.percona

% if grains['os_family'] == 'RedHat':
percona-xtradb-pkgs:
  pkg:
    - installed
    - names: 
      - Percona-XtraDB-Cluster-client
      - Percona-XtraDB-Cluster-server
    - require:
      - pkg: percona-repo

% else:

percona-xtradb-pkgs:
  pkg:
    - installed
    - names: 
      - percona-xtradb-cluster-client-5.5
      - percona-xtradb-cluster-server-5.5
      #- percona-xtrabackup
      - percona-xtradb-cluster-common-5.5
    - require:
      - pkg: percona-libmysqlclient18-pkg
      - pkgrepo: percona-pkgrepo

percona-libmysqlclient18-pkg:
  pkg:
    - installed
    - name: libmysqlclient18
    - version: latest
    - require:
      - pkgrepo: percona-pkgrepo

% endif

