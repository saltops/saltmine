saltmine
========

A curated collection of working salt states and configurations for use in your saltstack setup.

Please add your salt states here by opening a pull request! I aim to create the best collection of working salt states and configs possible.

The initial goal is to have states that are compatible with both RHEL and Debian distributions. If people show interest in additional compatibility, add it as a github issue.

Saltmine includes the following:

### common:
+ This collection is designed to be included in your salt project, and then included in your projects by including the `states` found here.

### examples:
+ Lots of example code and states.

### systems:
+ Other large builds that require state trees (such as setting up Openstack or complex db clusters) will be here.

### dependencies:
+ salt >= 0.12.0
+ mako >= 0.7.3

### installation:
+ clone this repo to your salt installation, and include the directory in the file_roots setting of your salt master.

Example: 
If you cloned saltmine within the /srv/ directory:

```yaml
base:
  - /srv/saltmine/
```

And then to add a module to your salt setup, simple ``include``.

Example:
```yaml
include:
  - saltmine.common.services.git
```
+ Include the saltmine  

### License: 
+ Code is licensed using Apache License 2.0
