SaltMine Philosophy
===================

+ SRY - Stop Repeating Yourself!
+ Abstract Appropriately and Often
+ Don't Break Compatibility
+ Intelligent defaults.
+ Minimize assumptions. Verify everything.
+ states are mako, but flexible templating for files.

### Named Keys Naming Conventions
Key types: (pkg, service, file)

+ pkg: `tomcat7-pkg`, `haproxy-pkg`
+ service: `tomcat7-service`, `haproxy-service`
+ file: `haproxy-cfg`, `motd-file` ( Include file extension in name if exists ``[filename]-[extension]``, else use ``[filename]-file`` )


### File and Directory Conventions:

+ Template files have a file extension with the template language name: ``motd.mako``
Separation of components
+ All sls files explicitly state the file type with the appropriate shebang at the top: ``#!yaml`` or ``#!mako|yaml``
+ Pillar variables stored in ``saltmine/pillar/env_globals.sls``
+ Files stored in ``saltmine/files/[statename]/[filename]``. Filename separators use underscores. Example: ``saltmine/files/haproxy/haproxy_logrotate``
+ test


### Pkg conventions:

+ saltmine/pkg/ files should install the latest program version by default. 
+ To install a specific version, you must set the appropriate global variable in your pillar file.
+ For users who with to compile, simply ``extend`` the appropriate service to not require the package. 

### Service state conventions:

+ Non-core services are given default states of ``dead`` and ``enable: False``. Services must be explicitly enabled and started in your state files. System services like crond or rsyslogd are core services and by default we can expect users to want them running.
+ Services are set to require the appropriate installation states
+ Default config files are set up with ``watch_in``. 
+ The service itself should not have a ``watch: file`` parameter. This is not very maintainable.



Use this:

```yaml
haproxy-service:
  service:
    - dead
    - name: haproxy
    - enable: 
      - false
    - require:
      - pkg: haproxy-pkg

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

### Extension Conventions:
All elements must use named and unique keys to enable easy extension.

Use this: 

```yaml
rsyslog-pkg:
  pkg.installed:
    - name: rsyslog
``` 

Instead of:

```yaml
rsyslog:
  pkg.installed
``` 

### TBI (To be implemented)

+ multiple state versions for different program versions
+ latest, or explicit installation versions
+ state testing 
