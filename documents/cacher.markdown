
The `debian::cacher` recipe install an Debian package caching proxy using [apt-cacher-ng][01].

# Configuration

Include the recipe `debian::cacher` to the run-list.

# Usage

Configure clients to use the caching proxy (example host name is `proxy.devops.test`):

    » echo 'Acquire::http { Proxy "http://proxy.devops.test:3142"; };' > /etc/apt/apt.conf.d/02proxy

Alternatively adjust `/etc/apt/sources.list` to point directly to the caching proxy.

Print a cache overview with:

    » /usr/lib/apt-cacher-ng/distkill.pl 
    Scanning /var/cache/apt-cacher-ng, please wait...
    Found distributions:
    bla, taggedcount: 0
         1. wheezy (29 index files)
         2. wheezy-updates (14 index files)

    Found architectures:
         3. amd64 (6 index files)
    [...SNIP...]

[01]: http://www.unix-ag.uni-kl.de/~bloch/acng
