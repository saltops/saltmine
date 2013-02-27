#!mako|yaml

# openstack-folsom glance setup

include:
  - saltmine.pkgs.epel
  - saltmine.pkgs.percona
  - saltmine.pkgs.ius

<%
  saltmine_openstack_mysql_root_username=pillar['saltmine_openstack_mysql_root_username']
  saltmine_openstack_mysql_root_password=pillar['saltmine_openstack_mysql_root_password']

  saltmine_openstack_glance_user=pillar['saltmine_openstack_glance_user']
  saltmine_openstack_glance_pass=pillar['saltmine_openstack_glance_pass']
  saltmine_openstack_keystone_ip=pillar['saltmine_openstack_keystone_ip']
  saltmine_openstack_keystone_auth_port=pillar['saltmine_openstack_keystone_auth_port']

  saltmine_openstack_keystone_service_token=pillar['saltmine_openstack_keystone_service_token']
  saltmine_openstack_keystone_service_endpoint=pillar['saltmine_openstack_keystone_service_endpoint']
  saltmine_openstack_keystone_service_tenant_name=pillar['saltmine_openstack_keystone_service_tenant_name']

  saltmine_openstack_OS_USERNAME=pillar['saltmine_openstack_OS_USERNAME']
  saltmine_openstack_OS_PASSWORD=pillar['saltmine_openstack_OS_PASSWORD']
  saltmine_openstack_OS_TENANT_NAME=pillar['saltmine_openstack_OS_TENANT_NAME']
  saltmine_openstack_keystone_ext_ip=pillar['saltmine_openstack_keystone_ext_ip']

%>

openstack-glance-pkg:
  pkg.installed:
    - names: 
      - openstack-glance
    - require: 
      - pkg: epel-repo

openstack-glance-db-create:
  cmd.run:
    - name: mysql -u root -e "CREATE DATABASE glance;"
    - unless: echo '' | mysql glance
    - require:
      - pkg: mysql-pkg
      - pkg: openstack-glance-pkg
    - watch_in:
      - cmd: openstack-glance-db-init

openstack-glance-db-init:
  cmd.run:
    - name: |
        mysql -u root -e "GRANT ALL ON glance.* TO '${saltmine_openstack_glance_user}'@'%' IDENTIFIED BY '${saltmine_openstack_glance_pass}';"
    - unless: |
        echo '' | mysql glance -u ${saltmine_openstack_glance_user} -h 0.0.0.0 --password=${saltmine_openstack_glance_pass}

openstack-glance-db-sync:
  cmd.wait:
    - name: glance-manage db_sync
    - watch:
      - cmd: openstack-glance-db-init
      - cmd: openstack-glance-db-create

% for svc in ['api','registry']:
openstack-glance-${svc}-service:
  service:
    - running
    - enable: True
    - name: openstack-glance-${svc}
    - require:
      - pkg: openstack-glance-pkg
% endfor

openstack-glance-api-paste-ini1:
  file.comment:
    - name: /etc/glance/glance-api-paste.ini
    - char: '#'
    - regex: '^delay_auth_decision = true'
    - require:
      - pkg: openstack-glance-pkg
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-api-paste-ini2:
  file.append:
    - name: /etc/glance/glance-api-paste.ini
    - text:
      - '[filter:authtoken]'
      - 'paste.filter_factory = keystone.middleware.auth_token:filter_factory'
      - 'auth_host = ${saltmine_openstack_keystone_ip}'
      - 'auth_port = 35357'
      - 'auth_protocol = http'
      - 'admin_tenant_name = ${saltmine_openstack_keystone_service_tenant_name}'
      - 'admin_user = ${saltmine_openstack_glance_user}'
      - 'admin_password = ${saltmine_openstack_OS_PASSWORD}'
    - require:
      - file: openstack-glance-api-paste-ini1
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-registry-paste-ini:
  file.append:
    - name: /etc/glance/glance-registry-paste.ini
    - text:
      - '[filter:authtoken]'
      - 'paste.filter_factory = keystone.middleware.auth_token:filter_factory'
      - 'auth_host = ${saltmine_openstack_keystone_ip}'
      - 'auth_port = 35357'
      - 'auth_protocol = http'
      - 'admin_tenant_name = ${saltmine_openstack_keystone_service_tenant_name}'
      - 'admin_user = ${saltmine_openstack_glance_user}'
      - 'admin_password = ${saltmine_openstack_OS_PASSWORD}'
    - require:
      - file: openstack-glance-api-paste-ini2
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-api-conf1:
  file.sed:
    - name: /etc/glance/glance-api.conf
    - before: 'mysql:.*'
    - after: 'mysql://${saltmine_openstack_glance_user}:${saltmine_openstack_glance_pass}@${saltmine_openstack_keystone_ip}/glance'
    - limit: '^sql_connection\ =\ '
    - require:
      - pkg: openstack-glance-pkg
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-api-conf2:
  file.append:
    - name: /etc/glance/glance-api.conf
    - text:
      - 'flavor = keystone'
    - require:
      - file: openstack-glance-api-conf1
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-registry-conf1:
  file.sed:
    - name: /etc/glance/glance-registry.conf
    - before: 'mysql:.*'
    - after: 'mysql://${saltmine_openstack_glance_user}:${saltmine_openstack_glance_pass}@${saltmine_openstack_keystone_ip}/glance'
    - limit: '^sql_connection\ =\ '
    - require:
      - pkg: openstack-glance-pkg
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync

openstack-glance-registry-conf2:
  file.append:
    - name: /etc/glance/glance-registry.conf
    - text:
      - 'flavor = keystone'
    - require:
      - file: openstack-glance-registry-conf1
    - watch_in:
      - service: openstack-glance-api-service
      - service: openstack-glance-registry-service
      - cmd: openstack-glance-db-sync