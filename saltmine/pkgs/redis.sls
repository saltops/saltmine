#!yaml

redis-pkg:
  pkg.installed:
% if grains['os_family'] == 'Debian':
    - name: redis-server
% elif grains['os_family'] == 'RedHat':
    - name: redis
    - require:
      - pkg: epel-repo
% endif