#!yaml

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
      - user: nginx
      - group: nginx