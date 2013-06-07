
The `debian::mirror` package installs and configures a 
Debian package archive mirror using `debmirror`.

# Configuration

**Attributes**

The `node.debian.mirror.path` attributes (default `/srv/mirror`) 
defines the location to store the package mirrors.

Attributes in `node.debian.mirrors`, are keys defining the relative 
path to store a particular mirror. Their values contain the 
configuration for `debmirror`. The recipe will generate executable
scripts in `/etc/mirror.d/` containing the configuration for
each mirror (details in the `debmirror` manual:

* `release` (required) – Release of the system (squeeze,lenny,stable,testing,etc)
* `arch` (default amd64) – Architecture (i386, powerpc, amd64, etc.)
* `section` (default main) – Section (main,contrib,non-free).
* `server` (default ftp.us.debian.org) – Server name of the node publishing the original archive.
* `path` (default `/debian`) – Path on the archive server.
* `proto` (default http) – Protocol to use for transfer (http, ftp, http, rsync)

Debian archive signature keys in the package `debain-archive-keyring` are 
used by default and added to the `~/.gnupg/trustedkeys.gpg` keyring used
by `debmirror`. You need to add additional keys for archives not 
present in this package!

**Examples**



# Usage
