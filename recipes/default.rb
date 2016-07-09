#
# Cookbook Name:: twemproxy
# Recipe:: default
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

%w(
  pytz
  python-magic
).each do |pkg|
  package pkg do
    action :install
  end
end

case node['twemproxy']['install_flavor']
when 'rpm'
  # rpm
  remote_file "/usr/local/src/#{node['twemproxy']['rpm']['file']}" do
    owner "root"
    group "root"
    mode 00644
    source "#{node['twemproxy']['rpm']['url']}#{node['twemproxy']['rpm']['file']}"
  end

  package "nutcracker" do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/usr/local/src/#{node['twemproxy']['rpm']['file']}"
  end
end

directory "/var/run/nutcracker" do
  owner "#{node['twemproxy']['user']}"
  group "#{node['twemproxy']['group']}"
  mode 00755
end

directory "#{node['twemproxy']['log_dir']}" do
  owner "#{node['twemproxy']['user']}"
  group "#{node['twemproxy']['group']}"
  mode 00755
end

template "/etc/nutcracker/nutcracker.yml" do
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[nutcracker]"
end

template "/etc/sysconfig/nutcracker" do
  owner "root"
  group "root"
  mode 00644
  source "nutcracker.sysconfig.erb"
  notifies :restart, "service[nutcracker]"
end

template "/etc/logrotate.d/nutcracker" do
  owner "root"
  group "root"
  mode 00644
  source "nutcracker.logrotate.erb"
end

service "nutcracker" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
