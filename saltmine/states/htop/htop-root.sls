#!yaml

include:
    - saltmine.services.htop

htoprc-root-file:
  file.managed:
    - name: /root/.htoprc
    - makedirs: True
    - source: salt://saltmine/files/htop/htoprc
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: htop-pkg