#!yaml

include:
  - saltmine.pkgs.rsyslog

rsyslog-service:
  service:
    - running
    - name: rsyslog
    - enable: True
    - require:
      - pkg: rsyslog-pkg