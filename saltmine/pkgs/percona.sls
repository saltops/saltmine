#!yaml

percona-repo:
  pkg.installed:
    - name: percona
    - sources:
      - percona-release: 'http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm'
      - percona-testing: 'http://repo.percona.com/testing/centos/6/os/noarch/percona-testing-0.0-1.noarch.rpm'
