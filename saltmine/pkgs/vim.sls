#!mako|yaml

vim-pkg:
  pkg:
    - installed
% if grains['os_family'] == 'Debian':
    - name: vim
% elif grains['os_family'] == 'RedHat':
    - name: vim-enhanced
% endif