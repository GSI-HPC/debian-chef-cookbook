
The _debian::mirror_ recipe installs and configures Debian package archive mirrors using `debmirror`. It will install Apache to server the local mirror.

↪ `attributes/mirror.rb`  
↪ `recipes/mirror.rb`  
↪ `tests/roles/debian_mirror_test.rb`  

## Configuration

Add the recipe _debian::mirror_ to the run-list and configure the source Debian package archive servers to be mirrored. 

**Attributes**

Attributes _node.debian.mirror_:

* _path_ (default `/srv/mirror`) – Base path to store all package mirrors.
* _user_ (default mirror) – User executing the mirror scripts.
* _notify_ (optional) – Mirror cronjob notification mail address.

Attributes in _node.debian.mirrors_ are keys defining the relative path to store a particular package archive mirror: Their values contain the configuration for `debmirror`. The recipe will generate executable scripts in `/etc/mirror.d/` containing the configuration for each mirror (details in the `debmirror` manual):

* _release_ (required) – Release of the system (squeeze,lenny,stable,testing,etc)
* _arch_ (default amd64) – Architecture (i386, powerpc, amd64, etc.)
* _section_ (default main) – Section (main,contrib,non-free).
* _server_ (default ftp.us.debian.org) – Server name of the node publishing the original archive.
* _path_ (default `/debian`) – Path on the archive server.
* _proto_ (default http) – Protocol to use for transfer (http, ftp, http, rsync)

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

GPG signatures from the package _debian-archive-keyring_ are used by default, and added to `~/.gnupg/trustedkeys.gpg` of the _node.debian.mirror.user_. List all the keys with:

    » gpg --list-keys --keyring ~/.gnupg/trustedkeys.gpg

Remember to add keys for non Debian repositories to be mirrored!

Following the example above, and assuming the mirror node is called _repo.devops.test_ adjust the following lines in `/etc/apt/sources.list` on the clients:

    deb http://repo.devops.test/debian/ wheezy main
    deb-src http://repo.devops.test/debian/ wheezy main

