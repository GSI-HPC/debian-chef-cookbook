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

# User account running the mirror scripts
user node['debian']['mirror']['user'] do
  home node['debian']['mirror']['path']
  supports :manage_home => true
  system true
end

# GPG keyring used by the mirror scripts
keyring = "#{node['debian']['mirror']['path']}/.gnupg/trustedkeys.gpg"
# Export upstream Debian keys
execute "Debian package archive keys added to #{keyring}" do
  creates keyring
  user node['debian']['mirror']['user']
  command "gpg --no-default-keyring --keyring #{keyring} " \
          "--import /usr/share/keyrings/debian-archive-keyring.gpg"
end

# TODO: use ruby-gpgme for key management
#
# we may want to add additional repos with non-standard keys to be
#  mirrored but not neccessarily trusted by the local apt setup:
#
node['debian']['mirror']['additional_keys'].each do |fingerprint,key|
  # TODO: inspect gpg key:
  #`gpg --with-fingerprint --with-colon <<< "#{key}"`
  execute "Adding repo key #{fingerprint}" do
    command "gpg --no-default-keyring --keyring #{keyring}" \
            " --import <<-EOD\n#{key}\nEOD"
    user node['debian']['mirror']['user']
    # without $HOME gpg tries to create /root/.gnupg :(
    environment ({'HOME' => node['debian']['mirror']['path']})
    not_if "gpg --no-default-keyring --keyring #{keyring} " \
           "--list-public-keys #{fingerprint}"
  end
end

# Holds the script to sync with package archives
directory '/etc/mirror.d'

# Configure all mirrors defined by attributes
node['debian']['mirrors'].each do |path,conf|
  # Make sure the archive directory exists
  storage = "#{node['debian']['mirror']['path']}/#{path}"
  directory storage do
    owner node['debian']['mirror']['user']
    recursive true
  end
  # Exit if no Debian release code name was defined
  unless conf.has_key? :release
    log("No release defined to mirror in: " + storage ) { level :fatal }
  end

  params = Mash.new.merge(conf)
  # Some defaults
  params[:arch] = ['amd64'] unless conf.has_key? :arch
  params[:section] = ['main'] unless conf.has_key? :section
  params[:server] = 'ftp.us.debian.org' unless conf.has_key? :server
  params[:proto] = 'http' unless conf.has_key? :proto
  params[:path] = '/debian' unless conf.has_key? :path
  params[:storage] = storage
  # Name of the mirror script.
  name = path.gsub(/\//,'_')
  # Generate the mirror script
  template "/etc/mirror.d/#{name}.sh" do
    source 'etc_mirror.d_generic.sh.erb'
    mode '0755'
    variables( :conf => params )
  end
end

unless node['debian']['mirror']['skip_apache_config']
  # Apache is used to server the mirror repsoitories
  service 'apache2' do
    supports :reload => true
  end
  # Generate the Apache configuration
  template '/etc/apache2/conf.d/mirror.conf' do
    source 'mirror_apache.conf.erb'
    variables( :path => node['debian']['mirror']['path'],
               :route => node['debian']['mirror']['route'] )
    notifies :reload, "service[apache2]", :delayed
  end
end

# FIXME: create a file in /etc/cron.d instead
cron 'debian_mirror_update' do
  user node['debian']['mirror']['user']
  minute node['debian']['mirror']['update_minute']
  hour node['debian']['mirror']['update_hour']
  day node['debian']['mirror']['update_day']
  unless node['debian']['mirror']['notify'].empty?
    mailto node['debian']['mirror']['notify']
  end
  home node['debian']['mirror']['path']
  # we cannot prevent this error message:
  command "run-parts --regex=.sh$ /etc/mirror.d/ 2>&1 | sed -e '/Warning: --rsync-extra is not configured to mirror the trace files\.$/{N;/ *This configuration is not recommended\./d}'"
end
