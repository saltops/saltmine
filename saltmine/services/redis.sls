#!mako|yaml

include:
  - saltmine.pkgs.redis

redis-service:
  service:
    - dead
    - enable:
      - false
    - require:
      - pkg: redis-pkg
% if grains['os_family'] == 'Debian':
    - name: redis-server
% elif grains['os_family'] == 'RedHat':
    - name: redis
% endif