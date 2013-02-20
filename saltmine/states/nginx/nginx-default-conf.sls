#!yaml

include:
  - saltmine.services.nginx

# delete the nginx default.conf file if it exists
nginx-default-conf:
  file.absent:
    - name:
      - /etc/nginx/conf.d/default.conf
    - require_in:
      - service: nginx-service
    - watch_in:
      - service: nginx-service