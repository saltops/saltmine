#!mako|yaml

<%
saltmine_crontab_path=pillar['saltmine_crontab_path']
saltmine_crontab_file_root=pillar['saltmine_crontab_file_root']
%>

include:
  - saltmine.services.crontab

# install a default crontab file with the path in it.

crontab-file:
  file.managed:
    - name: ${saltmine_crontab_file_root}
    - source: salt://saltmine/files/cron/crontab_template.mako
    - template: mako
    - watch_in:
      - cmd: crontab-load
    - defaults:
      saltmine_crontab_path: ${saltmine_crontab_path}

#Load crontab if /root/crontab-file differs from the crontab contents.
#http://docs.saltstack.org/en/latest/ref/states/all/salt.states.cmd.html#module-salt.states.cmd

crontab-load:
  cmd.run:
    - name: 'crontab -l | diff - ${saltmine_crontab_file_root}; crontab ${saltmine_crontab_file_root}'
    - cwd: /
    - unless: 'crontab -l | diff - ${saltmine_crontab_file_root}'
    - require:
      - pkg: crontab-pkg
