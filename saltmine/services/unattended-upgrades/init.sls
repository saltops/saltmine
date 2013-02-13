#!yaml

# https://help.ubuntu.com/10.04/serverguide/automatic-updates.html

unattended-upgrades-pkg:
  pkg.installed:
    - name: unattended-upgrades

10periodic-file:
  file.managed:
    - name: /etc/apt/apt.conf.d/10periodic
    - makedirs: True
    - source: salt://saltmine/services/unattended-upgrades/10periodic
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: unattended-upgrades-pkg
