#!mako|yaml

# Installs htop for a single named user set with a pillar key named: 'username'

include:
  - saltmine.pkgs.htop

<%
if 'username' in pillar:
  username=pillar['username']
else:
  username=None
%>

% if username is not None:

htoprc-user-file:
  file.managed:
    - name: '/home/${username}/.htoprc'
    - makedirs: True
    - source: salt://saltmine/files/htop/htoprc
    - user: ${username}
    - group: ${username}
    - mode: 0644
    - require:
      - pkg: htop-pkg

% endif