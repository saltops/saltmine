SaltMine
========

A curated collection of working salt states and configurations for use in your SaltStack setup.

Goals:
The aim of this project is to create a collection of Salt states with the following characteristics:

1. Easy to integrate with custom Salt setups.
2. Abstracts out differences in package names to simplify package installation.
3. Stable, with versioned 'releases' to guarantee compatibility as the project proceeds.
4. Well-tested, with comprehensive tests built for every state. (TODO!)
5. Flexible and Object-oriented, making it easy to extend and customize without modifying SaltMine code.
6. Community-oriented, with external contributions quickly reviewed and integrated.
7. Fun!

### Why are you doing ___ this way?

SaltMine's structure is designed to meet the day-to-day needs of regular saltstack users. The structure has
gone through many iterations so far, and there is a certain philosophy underpinning many of the design choices.
Take a look at our [SaltMine Philosophy](./philosophy.md) document for more information.

### Contributing:
Please contribute your Salt states here by opening a pull request on GitHub.

### Dependencies:

+ salt >= 0.12.0
+ mako >= 0.7.3
+ python >= 2.6

### Compatibility: 
The initial goal is to maintain compatibility with mainstream RHEL and Debian distributions. 
If people show interest in additional compatibility, please let us know by adding it as a GitHub issue,
or open pull requests with your modifications that add compatibility for your favorite repos.

### Installation:

+ Make sure that you have a working Salt installation (including mako)
+ Clone the SaltMine repo, (recommended cloning to /srv/) and include the SaltMine base directory in the file_roots setting of your salt master.
+ To make the SaltMine configs available to salt minions in all environments, (recommended) add the SaltMine repo base directory to your `base` environment.

If you cloned SaltMine within the /srv/ directory, ensure that the ``/srv/saltmine`` directory is added to the ``base`` file_roots environment in your Salt master config file:

```yaml
file_roots:
  base:
    - /srv/saltmine
```

+ Some of the states rely on pillar variables, so also add the saltmine pillar to the ``pillar_roots`` in your Salt master config file:

```yaml
pillar_roots:
  base:
    - /srv/saltmine/pillar
```

Alternatively, you can just add the appropriate variables to your current pillar files.

### Using SaltMine:

Once the SaltMine repo is included into your file_roots, to use SaltMine configs in your salt setup, simply ``include`` the appropriate service or state.

Examples:

```yaml
include:
  - saltmine.services.git
```

```yaml
include:
  - saltmine.services.haproxy
```

### License:

+ Code is licensed using Apache License 2.0
