#!yaml

include:
  - saltmine.states.nginx

# delete the nginx default.conf file if it exists
nginx-default-conf:
  file.absent:
% if grains['os_family'] == 'RedHat':
    - name: /etc/nginx/conf.d/default.conf
% else:
    - name: /etc/nginx/sites-enabled/default
% endif
    - watch_in:
      - service: nginx-service