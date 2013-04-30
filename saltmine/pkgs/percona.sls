#!mako|yaml

% if grains['os_family'] == 'RedHat':
percona-repo:
  pkg.installed:
    - name: percona
    - sources:
      - percona-release: 'http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm'
      - percona-testing: 'http://repo.percona.com/testing/centos/6/os/noarch/percona-testing-0.0-1.noarch.rpm'

% else:
# http://www.percona.com/doc/percona-xtradb-cluster/installation/apt_repo.html
percona-pkgrepo:
  pkgrepo.managed:
    - name: 'deb http://repo.percona.com/apt/ precise main'
    - disabled: True
    - keyid: 1C4CBDCDCD2EFD2A
    - keyserver: keys.gnupg.net

% endif

