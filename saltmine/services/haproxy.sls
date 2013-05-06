#!mako|yaml

include:
  - saltmine.pkgs.haproxy

haproxy-service:
  service:
    - running
    - name: haproxy
    - enable: 
      - True
    - require:
      - pkg: haproxy-pkg
      # - user: haproxy
      # - group: haproxy

% if grains['os_family'] == 'Debian':
haproxy-defaultfile:
  file.sed:
    - name: /etc/default/haproxy
    - before: 0
    - after: 1
    - limit: ^ENABLED=
    - require:
      - pkg: haproxy-pkg
    - watch_in:
      - service: haproxy-service
% endif