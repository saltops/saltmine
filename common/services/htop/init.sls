htop:
  pkg:
    - installed

/home/ubuntu/.htoprc:
  file.managed:
    - makedirs: True
    - source: salt://common/services/htop/htoprc
    - user: ubuntu
    - group: ubuntu
    - mode: 0644

/root/.htoprc:
  file.managed:
    - makedirs: True
    - source: salt://common/services/htop/htoprc
    - user: root
    - group: root
    - mode: 0644