#!yaml

include:
  - saltmine.services.nginx

nginx-conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - watch_in:
      - service: nginx-service
    - require:
      - service: nginx-service