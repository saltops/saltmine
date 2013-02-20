#!yaml

include:
  - saltmine.services.haproxy

haproxy-cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - watch_in:
      - service: haproxy-service
    - require: 
      - pkg: haproxy-pkg