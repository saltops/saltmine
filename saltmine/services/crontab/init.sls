#!mako|yaml

crontab-pkg:
  pkg:
% if grains.get('os_family') == 'RedHat':
    - name: crontabs
% else:
    - name: cron
% endif
    - installed

