#!yaml

epel-repo:
  pkg.installed:
    - name: epel-release
    - sources:
      - epel-release: 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'