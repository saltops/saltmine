#!yaml

include:
  - saltmine.states.nginx

# delete the nginx default.conf file if it exists
nginx-default-conf:
  file.absent:
    - name:
      - /etc/nginx/conf.d/default.conf
    - watch_in:
      - service: nginx-service