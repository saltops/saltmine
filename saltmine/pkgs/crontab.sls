#!mako|yaml

crontab-pkg:
  pkg:
% if grains['os_family'] == 'RedHat':
    - name: crontabs
% else:
    - name: cron
% endif
    - installed

