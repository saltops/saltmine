#!mako|yaml

<%
if 'boto_version' in pillar:
  boto_version=pillar['boto_version']
else:
  boto_version=None
%>

include:
  - saltmine.pkgs.pip

boto-pip-pkg:
  pip.installed:
    - name: boto
% if boto_version is None:
    - upgrade: True
    - require:
      - pkg: pip-pkg
% else:
    - require:
      - pkg: pip-pkg
      - cmd: boto-version-install
% endif


#http://pypi.python.org/simple/boto/
boto-version-install:
  cmd.run:
    - name: "pip install 'boto==${boto_version}'"
    - unless: "pip freeze 2> /dev/null | grep '^boto==${boto_version}'"
    - require: 
      - pkg: pip-pkg


# boto-pip-pkg:
#   pip.installed:
#     - name: 'boto'
#     - version: 2.6.0
#     - require:
#       - pkg: python-pip-pkg
