#!mako|yaml

include:
  - saltmine.pkgs.nginx

nginx-service:
  service:
    - running
    - name: nginx
    - enable: 
      - True
    - require:
      - pkg: nginx-pkg
% if grains['os_family'] == 'Debian':
      - user: www-data
      - group: www-data
% else:
      - user: nginx
      - group: nginx
% endif