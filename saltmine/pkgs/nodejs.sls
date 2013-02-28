#!yaml

nodejs-lea-repo:
  pkgrepo.managed:
    - name: 'deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu/ precise main'
    - disabled: True
    - keyid: C7917B12
    - keyserver: keyserver.ubuntu.com

nodejs-pkg:
  pkg.installed:
    - names:
      - nodejs
      - npm
      - g++
    - require:
      - pkgrepo: nodejs-lea-repo