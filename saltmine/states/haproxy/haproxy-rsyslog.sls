#!yaml

include:
  - saltmine.service.rsyslog

haproxy-logrotate:
  file.managed:
    - name: /etc/logrotate.d/haproxy
    - source: salt://saltmine/files/haproxy/haproxy_logrotate
    - require:
      - pkg: rsyslog-pkg

haproxy-rsyslog-conf:
  file.managed:
    - name: /etc/rsyslog.d/haproxy.conf
    - source: salt://saltmine/files/haproxy/haproxy_syslog_conf
    - require:
      - file: haproxy-logrotate

rsyslog-logdir:
  file.directory:
    - name: /var/log/haproxy/
    - user: haproxy
    - mode: 755
    - makedirs: True
    - require:
      - file: haproxy-rsyslog-conf
