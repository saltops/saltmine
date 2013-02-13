#!mako|yaml

<%
#crontab_path:'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
crontab_path=pillar['crontab_path']
%>

include:
  - saltmine.services.crontab

# install a default crontab file with the path in it.

crontab-file:
  file.managed:
    - name: /root/crontab-file
    - source: salt://saltmine/states/cron/crontab-template
    - template: mako
    - defaults:
      crontab_path: ${crontab_path}

#Load crontab if /root/crontab-file differs from the crontab contents.

crontab-load:
  cmd.wait:
    - name: crontab /root/crontab-file
    - cwd: /
    - unless: 'crontab -l | diff - /root/crontab-file'
    - watch:
      - file: crontab-file
    - require:
      - pkg: crontab-pkg



