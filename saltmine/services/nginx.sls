#!yaml

include:
  - saltmine.pkgs.nginx

nginx-service:
  service:
    - dead
    - name: nginx
    - enable: False
    - require:
      - pkg: nginx-pkg
      - user: nginx
      - group: nginx