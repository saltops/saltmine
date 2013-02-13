#!mako|yaml

#http://askubuntu.com/questions/56683/where-is-the-cron-crontab-log
% if salt['file.file_exists']('/etc/rsyslog.d/50-default.conf'):

cron-logging:
  file.append:
    - name: /etc/rsyslog.d/50-default.conf
    - text:
      - 'cron.*                         /var/log/cron.log'

rsyslog-service:
  service.running:
    - name: rsyslog
    - watch:
      - file: cron-logging

% endif