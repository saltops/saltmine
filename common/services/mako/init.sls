#!yaml
#mako: make sure that mako is installed properly when minions start up.
#https://github.com/saltstack/salt-cloud/issues/230

python-pip:
  pkg.installed

mako:
  pip.installed:
    - name: mako
    - require:
      - pkg: python-pip
