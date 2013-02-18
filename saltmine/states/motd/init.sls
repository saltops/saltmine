#!yaml

motd-file:
  file:
    - managed
    - name: /etc/motd
    - template: mako
    - user: root
    - group: root
    - mode: 444
    - source: salt://saltmine/files/motd/motd.mako