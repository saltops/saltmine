#!mako|yaml

#http://askubuntu.com/questions/56683/where-is-the-cron-crontab-log

% if salt['file.file_exists']('/etc/rsyslog.d/50-default.conf'):
cron-logging:
  file.uncomment:
    - name: /etc/rsyslog.d/50-default.conf
    - regex: cron\.
% endif