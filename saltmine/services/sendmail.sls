#!yaml

include:
  - saltmine.pkgs.sendmail

sendmail-service:
  service:
    - running
    - name: sendmail
    - enable: 
      - True
    - require:
      - pkg: sendmail-pkg