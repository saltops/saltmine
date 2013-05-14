#!yaml

include:
  - saltmine.services.rsyslog

rsyslog-conf:
  file.managed:
    - name: /etc/rsyslog.conf
    - watch_in:
      - service: rsyslog-service