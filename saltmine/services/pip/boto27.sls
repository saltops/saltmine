#!mako|yaml

<%
boto_version='2.7.0'
%>

include:
  - saltmine.services.pip

#http://pypi.python.org/simple/boto/

boto-upgrade-runner:
  cmd.run:
    - name: "pip install 'boto==${boto_version}'"
    - unless: "pip freeze 2> /dev/null | grep '^boto==${boto_version}'"
    - require:
      - cmd: python-pip-cmd

boto-pip-pkg:
  pip.installed:
    - name: boto
    - require:
      - cmd: boto-upgrade-runner
      - cmd: python-pip-cmd


# boto-pip-pkg:
#   pip.installed:
#     - name: 'boto'
#     - version: 2.6.0
#     - require:
#       - pkg: python-pip-pkg
