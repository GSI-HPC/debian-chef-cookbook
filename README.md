# Description

The "debian" cookbook deploys Debian package mirrors and local package repositories.

**Requirements**

* Chef version >= 10.12
* No dependencies to other cookbooks.

**Platforms**

* Debian (Wheezy)
* No other platforms supported yet.

# Usage

The "debian" cookbook has no default recipe. Include one of the following recipes to the run-list:

* _fai_ – Unattended installation for Debian over the network. (NOT IMPLEMENTED YET)
* _mirror_ – Deploy a Debian package mirror. [Details...](documents/mirror.markdown)
* _cacher_ – Deploy a Debian package caching proxy. [Details...](documents/cacher.markdown)
* _repo_ – Deploy a local package repository. [Details...](documents/repo.markdown)

# License

Copyright 2013 Victor Penso

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


