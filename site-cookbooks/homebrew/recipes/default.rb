#
# Author:: Joshua Timberman (<jtimberman@opscode.com>)
# Author:: Graeme Mathieson (<mathie@woss.name>)
# Cookbook Name:: homebrew
# Recipes:: default
#
# Copyright 2011-2013, Opscode, Inc.
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

self.extend(Homebrew::Mixin)

homebrew_go = "#{Chef::Config[:file_cache_path]}/homebrew_go"
owner = homebrew_owner

Chef::Log.debug("Homebrew owner is '#{homebrew_owner}'")

remote_file homebrew_go do
  source "https://raw.github.com/mxcl/homebrew/go"
  mode 00755
end

execute homebrew_go do
  user owner
  not_if { ::File.exist? '/usr/local/bin/brew' }
end

package 'git' do
  not_if "which git"
end

execute "update homebrew from github" do
  user owner
  command "/usr/local/bin/brew update || true"
end

%w{zsh htop git zip unzip svn wget ack md5 nkf iotop iftop rdesktop}.each do |p|
  package p do
    action :install
  end
end
