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

