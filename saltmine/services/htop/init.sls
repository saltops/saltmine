#!mako|yaml

% if grains['os_family'] == 'RedHat':
include:
  - saltmine.services.repos.epel
% endif


htop-pkg:
  pkg:
    - installed
    - name: htop
% if grains['os_family'] == 'RedHat':
    - require:
      - pkg: epel-repo
% endif

/root/.htoprc:
  file.managed:
    - makedirs: True
    - source: salt://saltmine/services/htop/htoprc
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: htop-pkg
