#!yaml

#rsyslog init.sls

rsyslog-service:
  service:
    - running
    - name: rsyslog
    - enable: True
    - require:
      - pkg: rsyslog-pkg      

rsyslog-pkg:
  pkg.installed:
    - name: rsyslog



