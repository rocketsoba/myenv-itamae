# coding: utf-8
if node["platform"] != "redhat" && node["platform_version"] != 6.9 then
  exit(1)
end

execute "update yum repo" do
  user "root"
  command "yum -y update"
end

if node["userdata"]["flag"] == 1 then
  user node["userdata"]["name"] do
    password node["userdata"]["password"]
  end
end

user node["userdata"]["name"] do
  gid node["userdata"]["group"]
end

template "/etc/sudoers" do
  source "templates/sudoers"
  mode   "440"
  owner  "root"
  group  "root"
end

template "/home/#{node["userdata"]["name"]}/.bash_profile" do
  source "templates/.bash_profile"
  owner  node["userdata"]["name"]
  group  node["userdata"]["name"]
end

directory "/home/"+node["userdata"]["name"]+"/.ssh" do
  owner node["userdata"]["name"]
  mode "700"
end

hosts = "templates/hosts.orig"
hosts_dst = "templates/hosts"
hostlist = File.read hosts
lines = {
  "hostname4" => node["hostname"],
  "hostname6" => node["hostname"],
}

lines.each do |line, rewrite|
  hostlist = hostlist.gsub("#{line}", "#{rewrite}")
end

File.open hosts_dst, "w" do |file|
  file.write hostlist
end

template "/etc/hosts" do
  source "templates/hosts"
  mode   "644"
  owner  "root"
  group  "root"
end





node["packages"]["base"].each do |ele1|
  package ele1[1]
end

node["packages"]["epel"].each do |ele1|
  package ele1[1] do
    options "--enablerepo=epel"
  end
end

package "https://centos6.iuscommunity.org/ius-release.rpm" do
  not_if "rpm -q ius-release"
end

node["packages"]["ius"].each do |ele1|
  package ele1[1] do
    options "--enablerepo=ius"
  end
end

package "http://rpms.famillecollet.com/enterprise/remi-release-6.rpm" do
  not_if "rpm -q remi-release"
end

