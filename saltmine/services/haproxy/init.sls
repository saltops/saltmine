#!mako|yaml

haproxy-pkg:
  pkg: 
    - installed
    - name: haproxy

haproxy-cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg

haproxy-service:
  service:
    - dead
    - name: haproxy
    - enable: 
      - false
    - watch:
      - file: haproxy-cfg
    - require:
      - pkg: haproxy-pkg

% if grains['os_family'] == 'Debian':
haproxy-defaultfile:
  file.sed:
    - name: /etc/default/haproxy
    - before: 0
    - after: 1
    - limit: ^ENABLED=
    - require:
      - pkg: haproxy-pkg
    - require_in:
      - service: haproxy-service
    - watch_in:
      - service: haproxy-service
% endif