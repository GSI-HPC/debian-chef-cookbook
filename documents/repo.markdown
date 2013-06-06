
The `debian::repo` recipe installs and configures a local Debian package repositories using [reprepro][01].

↪ `attributes/repo.rb`  
↪ `recipe/repo.rb`  
↪ `template/*/repo_apache.conf.erb`  
↪ `template/*/repo_conf_distributions.erb`  
↪ `template/*/repo_key.conf.erb`  
↪ `tests/roles/debian_repo_test.rb`  
↪ `tests/roles/debian_repo_with_password_test.rb`  

# Configuration

Including the `debian::repo` recipe to the run-list will lead to the installation of Apache to server the [reprepro][01] maintained package repository.

**Attributes**

All attributes in `node.debian.repo`:

* `path` (default `/srv/repo`) – Path to the package repository.
* `distrib` (required) – Configuration file for the repository in `conf/distribution` (see `reprepro` manual).
* `key` (required) – Configuration for the GPG repository signing (see `gpg` manual).
* `options` (optional) – Options for `reprepro` (see manual).

**Examples**

The minimum configuration describes your project/organization details:

    "debian" => {
      "repo" => {
        "distrib" => {
          "Origin" => "Devops Lab",
          "Label" => "devops",
          "Description" => "Devops packages from the Lab."
        },
        "key" => {
          "Name-Real" => "Devops Lab",
          "Name-Comment" => "Devops packages from the Lab.",
          "Name-Email" => "packages@devops.test"
        }
      }
    }


In order to protect package signing with a pass-phrase add the following attributes to the configuration:

    "debian" => {
      "repo" => 
        [...SNIP...]
        "key" => {
          [...SNIP...]
          "Passphrase" => "secret"
        },
        "options" => [ "ask-passphrase" ]
      }
    }

The `reprepro` command will the prompt for the password when is signs a package.

# Usage

This will create a new repository in `node.debian.repo.path`. A new GPG key (without pass-phrase) will be generated and its public subkey written to the file `gpg.key` inside the repository. 

Add new packages to the repository using `reprepro`, for example:

    » reprepro -b /srv/repo includedeb wheezy /path/to/package/name_0.0.1_amd64.deb
    » reprepro -b /srv/repo list wheezy
    [...SNIP...]

Clients can connect to the repository doing something like (example host name is `repo.devops.test`):

    » wget -O - http://repo.devops.test/debian/gpg.key | apt-key add -
    » echo "deb http://repo.devops.test/debian wheezy main" > /etc/apt/sources.list.d/devops.list
    » apt-get update
    [...SNIp...]


[01]: http://mirrorer.alioth.debian.org
