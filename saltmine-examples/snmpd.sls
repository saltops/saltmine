#!yaml

# Equivalent to:
# aptitude install snmpd 
# /etc/init.d/snmpd stop
# echo 'foo' > /var/lib/snmp/snmpd.conf
# cat snmpd_template.conf > /etc/snmp/snmpd.conf
# /etc/init.d/snmpd start

snmpd:
  pkg.installed
  service:
    - running
    - name: snmpd
    - enable: True
    - watch:
      - file: /etc/snmp/snmpd.conf
    - order: 1

snmpd:
  service:
    - dead
    - order: 2

snmpd-customized:
  file.append:
    - name: /var/lib/snmp/snmpd.conf
    - text:
      - foo

/etc/snmp/snmpd.conf
  file.managed:
    - source: salt://snmp/snmpd.conf
    - user: root
    - group: root
    - mode: 644
