#!mako|yaml

% if grains['os_family'] == 'RedHat':
include:
  - saltmine.services.repos.epel
% endif

s3cmd-pkg:
  pkg.installed:
    - name: s3cmd
% if grains['os_family'] == 'RedHat':
    - require:
      - pkg: epel-repo
% endif