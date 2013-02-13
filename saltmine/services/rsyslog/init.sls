#!yaml

#rsyslog init.sls

rsyslog-service:
  service:
    - running
    - name: rsyslog
    - enable: True
    - watch:
      - file: haproxy-rsyslog-conf
    - require:
      - pkg: rsyslog-pkg      

haproxy-logrotate:
  file.managed:
    - name: /etc/logrotate.d/haproxy
    - source: salt://saltmine/services/rsyslog/haproxy_logrotate
    - require:
      - pkg: rsyslog-pkg

haproxy-rsyslog-conf:
  file.managed:
    - name: /etc/rsyslog.d/haproxy.conf
    - source: salt://saltmine/services/rsyslog/haproxy_syslog_conf
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

rsyslog-pkg:
  pkg.installed:
    - name: rsyslog

