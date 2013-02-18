#!yaml

include:
  - saltmine.pkgs.pip
  
pip-virtualenv-module:
  pip.installed:
    - name: 'virtualenv'
    - require:
      - cmd: python-pip-cmd