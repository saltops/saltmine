#!mako|yaml

## Global pillars for saltmine examples

saltmine_message_do_not_modify: 'This file is managed by Salt. Do Not Modify.'
saltmine_hostname: ${grains['id']}

## crontab settings
saltmine_crontab_path: 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
saltmine_crontab_file_root: '/root/crontab_file_root'

## App Version Settings
saltmine_boto_version: '2.7.0'
saltmine_nodejs_version: '0.9.10'
