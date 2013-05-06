#!yaml

include:
  - saltmine.pkgs.tomcat7

tomcat7-service:
  service:
    - running
    - name: tomcat7
    - enable: 
      - True
    - require:
      - pkg: tomcat7-pkg