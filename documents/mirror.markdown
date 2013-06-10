
The `debian::mirror` recipe installs and configures Debian package archive mirrors using `debmirror`. It will install Apache to server the local mirror.

↪ `attributes/mirror.rb`  
↪ `recipes/mirror.rb`  
↪ `tests/roles/debian_mirror_test.rb`  

## Configuration

Add the recipe `debian::mirror` to the run-list and configure the source Debian package archive servers to be mirrored. 

**Attributes**

Attributes `node.debian.mirror`:

* `path` (default `/srv/mirror`) – Base path to store all package mirrors.
* `notify` (optional) – Mirror cronjob notification mail address.

Attributes in `node.debian.mirrors` are keys defining the relative path to store a particular package archive mirror: Their values contain the configuration for `debmirror`. The recipe will generate executable scripts in `/etc/mirror.d/` containing the configuration for each mirror (details in the `debmirror` manual):

* `release` (required) – Release of the system (squeeze,lenny,stable,testing,etc)
* `arch` (default amd64) – Architecture (i386, powerpc, amd64, etc.)
* `section` (default main) – Section (main,contrib,non-free).
* `server` (default ftp.us.debian.org) – Server name of the node publishing the original archive.
* `path` (default `/debian`) – Path on the archive server.
* `proto` (default http) – Protocol to use for transfer (http, ftp, http, rsync)

Debian archive signature keys in the package `debain-archive-keyring` are used by default and added to the `~/.gnupg/trustedkeys.gpg` keyring used by `debmirror`. You need to add additional keys for archives not present in this package if needed!

**Examples**

Mirror the main repositories of Debian Wheezy and Debian Lenny:

    :debian => {
      :mirrors => {
        "wheezy" => {
          :arch => ["i386","amd64"],
          :section => ["main","contrib","non-free"],
          :release => ["wheezy"],
          :server => "ftp.de.debian.org"
        },
        "archive/lenny" => {
          :arch => ["i386","amd64"],
          :section => ["main","contrib","non-free"],
          :release => ["lenny"],
          :server => "archive.debian.org",
          :path => "/debian-archive/debian",
          :proto => "ftp"
        }
    }

This will generate the script `/etc/mirror.d/wheezy.sh` to store the mirror in `/srv/mirror/wheezy`, and the script `/etc/mirror.d/archive_lenny.sh` string the mirror to /srv/mirror/archive/lenny`.

## Usage


