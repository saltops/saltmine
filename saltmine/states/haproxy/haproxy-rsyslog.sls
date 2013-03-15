#!yaml

include:
  - saltmine.services.rsyslog

haproxy-logrotate:
  file.managed:
    - name: /etc/logrotate.d/haproxy
    - source: salt://saltmine/files/haproxy/haproxy_logrotate
    - watch_in:
      - service: rsyslog-service

haproxy-rsyslog-conf:
  file.managed:
    - name: /etc/rsyslog.d/haproxy.conf
    - source: salt://saltmine/files/haproxy/haproxy_syslog_conf
    - watch_in:
      - service: rsyslog-service

rsyslog-logdir:
  file.directory:
    - name: /var/log/haproxy/
    - user: haproxy
    - mode: 755
    - makedirs: True
    - watch:
      - service: rsyslog-service
