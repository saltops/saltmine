SaltMine Conventions
====================

+ SRY - Stop Repeating Yourself!
+ Abstract Appropriately and Often
+ Don't Break Compatibility
+ Intelligent defaults.
+ Minimize assumptions. Verify everything.
+ Base templating language is mako

### Naming `Named` Keys:
All elements must use named and unique keys to enable easy extension.

+ Key types: (pkg, service, file, pillar, states)
+ pkg: `tomcat7-pkg`, `haproxy-pkg`
+ service: `tomcat7-service`, `haproxy-service`
+ file: `haproxy-cfg`, `motd-file` ( Include file extension in name if exists ``[filename]-[extension]``, else use ``[filename]-file`` )
+ pillar: `saltmine_+[variablename]`
+ states: `[statename]/descriptivename.sls`

### Files and Directories:

+ Template files have a file extension with the template language name: ``motd.mako``
+ All sls files explicitly state the file type with the appropriate shebang at the top: ``#!yaml`` or ``#!mako|yaml``
+ Pillar variables stored in ``saltmine/pillar/env_globals.sls``
+ Files stored in ``saltmine/files/[statename]/[filename]``. Filename separators use underscores. Example: ``saltmine/files/haproxy/haproxy_logrotate``

### Map Files:

+ Include salt-cloud maps and profiles in named directories in ``/saltmine/maps/``

### Pkg Files:

+ pkg files should be in named files that correspond to the commonly accepted program name, and not the package name. e.g. ``saltmine/pkgs/pip.sls`` instead of ``saltmine/pkgs/python-pip.sls``
+ ``saltmine/pkg/`` files should install the latest program version by default. 
+ pkg sls files should allow to install a specific version by setting a global variable in your pillar file. e.g. for boto, the pillar variable would be ``saltmine_boto_version``

### Services:

+ Non-core services are given default states of ``dead`` and ``enable: False``. Services must be explicitly enabled and started in your state files. System services like crond or rsyslogd are core services and by default we can expect users to want them running.
+ Services are set to require the appropriate installation states
+ The service itself should not have a ``watch: file`` parameter. This is not very maintainable.

### States:

+ states should be included in named directories in ``/saltmine/states/``
+ Default config files are set up in the init.sls file in the states directory 
+ Use ``watch_in`` and ``require_in``, etc. to modify the service that the state file depends on. 


Use this:

```yaml
# /saltmine/service/haproxy.sls
haproxy-service:
  service:
    - dead
    - name: haproxy
    - enable: 
      - false
    - require:
      - pkg: haproxy-pkg

# /saltmine/states/haproxy/init.sls
haproxy-cfg:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - watch_in:
      - service: haproxy-service
```

with usage like this:

```yaml
include:
  - saltmine.states.haproxy

extend:
  haproxy-service:
    service:
      - running
      - enable:
        - true
```

Instead of:

```yaml
haproxy:
  service:
    - running
    - enable: 
      - true
    - watch:
      - file: /etc/haproxy/haproxy.cfg
    - require:
      - pkg: haproxy
```

### Pillar Variables:

+ All saltmine pillar variables begin with ``saltmine_``. E.g. ``saltmine_boto_version``
+ Use simple `key: value` pairs only for easy extensibility. E.g. ``saltmine_boto_version: '2.7.0'``

### TBI (To be implemented)

+ state testing standards