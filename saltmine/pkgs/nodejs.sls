#!mako|yaml

<%
  node_version = pillar['node']['version']
%>

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

node-n:
  cmd.run:
    - name: |
        npm install -g n
        n ${node_version}
    - shell: /bin/bash
    - unless: |
        [ `/usr/local/bin/node --version` == "v${node_version}" ] 
