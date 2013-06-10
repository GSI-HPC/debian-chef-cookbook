#
# Cookbook Name:: debian
# Recipe:: mirror
#
# Copyright 2013, Victor Penso
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'apache2'
package 'debian-archive-keyring'
package 'debmirror'
package 'debianutils'

keyring = "#{ENV['HOME']}/.gnupg/trustedkeys.gpg"
execute "Debian package archive keys added to #{keyring}" do
  command "gpg --no-default-keyring --keyring trustedkeys.gpg --import /usr/share/keyrings/debian-archive-keyring.gpg"
  not_if do ::File.exists? keyring end
end

# Holds the script to sync with package archives
directory '/etc/mirror.d'
# Configure all mirrors defined by attributes
node.debian.mirrors.each do |path,conf|
  # Make sure the archive directory exists
  storage = "#{node.debian.mirror.path}/#{path}"
  directory storage do
    recursive true
  end
  # Exit if no Debian release code name was defined
  unless conf.has_key? :release
    log("No release defined to mirror in: " + storage ) { level :fatal }
  end
  # Some defaults 
  conf[:arch] = ['amd64'] unless conf.has_key? :arch
  conf[:section] = ['main'] unless conf.has_key? :section
  conf[:server] = 'ftp.us.debian.org' unless conf.has_key? :server
  conf[:proto] = 'http' unless conf.has_key? :proto
  conf[:path] = '/debian' unless conf.has_key? :path
  conf[:storage] = storage
  # Name of the mirror script.
  name = path.gsub(/\//,'_')
  # Generate the mirror script
  template "/etc/mirror.d/#{name}.sh" do
    source 'etc_mirror.d_generic.sh.erb'
    mode "0700"
    variables( :conf => conf )
  end
end

# Apache is used to server the mirror repsoitories
service 'apache2' do
  supports :reload => true
end
# Generate the Apache configuration
template '/etc/apache2/conf.d/mirror.conf' do
  source 'mirror_apache.conf.erb'
  variables( :path => node.debian.mirror.path )
  notifies :reload, "service[apache2]", :delayed
end

cron 'debian_mirror_update' do
  minute '0'
  hour '2'
  day '*'
  mailto node.debian.mirror.notify unless node.debian.mirror.notify.empty?
  home '/srv/mirror'
  command <<-EOF
    run-parts --regex=.sh$ /etc/mirror.d/
  EOF
end

