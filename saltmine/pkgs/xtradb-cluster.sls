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
      - percona-xtrabackup
    - require:
      - pkgrepo: percona-pkgrepo

% endif
