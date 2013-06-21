#!mako|yaml

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
    - require:
      - file: mnt-data-dir
