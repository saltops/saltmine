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

# /etc/haproxy/:
#   file.directory:
#     - user: root
#     - group: http
#     - mode: 750