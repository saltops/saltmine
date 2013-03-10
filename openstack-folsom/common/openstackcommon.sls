#!yaml

ntp-pkg:
  pkg.installed:
    - names: 
      - ntp

ntp-service:
  service:
    - name: ntpd
    - running
    - enable: True
    - require:
      - pkg: ntp-pkg

bridge-utils-pkg:
  pkg.installed:
    - names: 
      - bridge-utils

ip-forwarding-enable:
  sysctl:
    - name: net.ipv4.ip_forward
    - present
    - value: "1"
