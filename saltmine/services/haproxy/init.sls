#!yaml

haproxy:
  pkg: 
    - installed
  service:
    - dead
    - enable: 
      - True
    - watch:
      - file: /etc/haproxy/haproxy.cfg