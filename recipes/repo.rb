#
# Cookbook Name:: debian
# Recipe:: repo
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
package 'reprepro'

directory node.debian.repo.path do
  recursive true
end

[ 'conf', 'dists', 'pool', ].each do |sub_dir|
  directory "#{node.debian.repo.path}/#{sub_dir}" do
    owner 'root'
    group 'www-data'
  end
end

service 'apache2' do
  supports :reload => true
  action :enable
end

template '/etc/apache2/conf.d/repo.conf' do
  source 'repo_apache.conf.erb'
  variables( :path => node.debian.repo.path )
  notifies :reload, "service[apache2]", :delayed
end

# Install support or GPG package signing
package 'gnupg-agent'
# Used to accelerate entropy generation for the GPG key creation
package 'rng-tools'

# Configuration for the GPG key generation (only temporary)
key_conf ="#{node.debian.repo.path}/key.conf"
# Public subkey for repository
repo_key = "#{node.debian.repo.path}/gpg.key"
# Mail address of key owner
mail = node.debian.repo['key']['Name-Email']

# Write the configuration file for the GPG key creation
template key_conf do
  source 'repo_key.conf.erb'
  mode '0600'
  variables( :conf => node.debian.repo['key'] )
  # unless a subkey for the repository had been created already
  not_if do ::File.exists? repo_key end
end

# Create the repository GPG key and subkey
execute "Create repository GPG key" do
  command <<-EOF
    rngd -r /dev/urandom
    gpg --batch --gen-key #{key_conf}
    pkill rngd
  EOF
  not_if "gpg --list-keys #{mail}"
end

# Extract the subkey and write it to the repository
execute "Export GPG subkey to repository" do
  command <<-EOF
    id=$(gpg --list-keys #{mail} | grep sub | sed 's|/| |g' | awk '{print $3}')
    gpg --armor --output #{repo_key} --export $id
  EOF
  not_if do ::File.exists? repo_key end
end

# Make sure to remove the GPG configuration file
file key_conf do
  backup false
  action :delete
end

ruby_block "Read GPG subkey ID" do
  block do
    # Add the GPG subkey ID to the configuration for automatic package signing
    key_id = `gpg --list-keys #{mail} | grep sub | sed 's|/| |g' | awk '{print $3}'`
    node.default['debian']['repo']['distrib']['SignWith'] = key_id
  end
end

# Write the repository configuration
template "#{node.debian.repo.path}/conf/distributions" do
  source 'repo_conf_distributions.erb'
  owner 'root'
  group 'www-data'
  variables( :distrib => node.debian.repo.distrib )
end

unless node.debian.repo.options.empty?
  file "#{node.debian.repo.path}/conf/options" do
    content node.debian.repo.options.join("\n") + "\n"
    mode '0600'
  end
end



