# https://help.ubuntu.com/10.04/serverguide/automatic-updates.html

unattended-upgrades:
  pkg.installed

/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - makedirs: True
    - source: salt://common/services/unattended-upgrades/10periodic
    - user: root
    - group: root
    - mode: 0644