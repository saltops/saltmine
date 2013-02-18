#!yaml

include:
  - saltmine.pkgs.tomcat7

tomcat7-service:
  service:
    - dead
    - name: tomcat7
    - enable: False
    - require:
      - pkg: tomcat7-pkg