#!mako|yaml

# Installs htop for a single named user set with a pillar key named: 'username'

include:
    - saltmine.services.htop

<%
username=pillar['username']
%>

% if username:

/home/${username}/.htoprc:
  file.managed:
    - makedirs: True
    - source: salt://saltmine/services/htop/htoprc
    - user: ${username}
    - group: ${username}
    - mode: 0644
    - require:
      - pkg: htop-pkg

% endif