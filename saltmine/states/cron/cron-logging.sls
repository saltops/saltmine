#!mako|yaml

#http://askubuntu.com/questions/56683/where-is-the-cron-crontab-log
% if salt['file.file_exists']('/etc/rsyslog.d/50-default.conf'):

include:
  - saltmine.services.rsyslog

cron-logging:
  file.append:
    - name: /etc/rsyslog.d/50-default.conf
    - text:
      - 'cron.*                         /var/log/cron.log'
    - watch_in:
      - service: rsyslog-service

% endif