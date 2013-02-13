#!mako|yaml

## Example Usage:
# Here's an example of how to use our fully-managed cron. For every desired cron entry,
# simply add an additional file.accumulated entry, as shown below:

include:
  - saltmine.services.cron-defaults

<%
saltmine_crontab_file_root=pillar['saltmine_crontab_file_root']
%>

myscript-cron-accumulate:
  file.accumulated:
    - name: mycrontab
    - filename: ${saltmine_crontab_file_root}
    - text:
      - '4 * * * * python /root/myscript.py'
    - require_in: 
      - file: crontab-file

shellcommand-cron-accumulate:
  file.accumulated:
    - name: mycrontab
    - filename: ${saltmine_crontab_file_root}
    - text:
      - '8 * * * * sh /home/ubuntu/shellcommand.sh
    - require_in: 
      - file: crontab-file