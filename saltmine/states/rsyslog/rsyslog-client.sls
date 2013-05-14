#!mako|yaml

<%
rsyslog_server_address = pillar['saltmine_rsyslog_server_address']
%>

include:
  - saltmine.services.rsyslog

rsyslog-conf:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://saltmine/files/rsyslog/rsyslog.conf-client
    - template: mako
    - defaults:
        rsyslog_server_address: ${rsyslog_server_address}
    - watch_in:
      - service: rsyslog-service