#!mako|yaml

include:
  - saltmine.pkgs.redis

redis-service:
  service:
    - running
    - enable:
      - True
    - require:
      - pkg: redis-pkg
% if grains['os_family'] == 'Debian':
    - name: redis-server
% elif grains['os_family'] == 'RedHat':
    - name: redis
% endif