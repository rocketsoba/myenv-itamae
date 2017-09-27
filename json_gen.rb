# coding: utf-8
require 'json'

if File.exist?("hashed_pass")
  password = File.read("hashed_pass");
  password.strip!
  flag = 1
else
  password = ""
  flag = 0
end

data = {
  "userdata" => {
    "name" => "yakisoba",
    "password" => password,
    "group" => "10",
    "flag" => flag,
  },
  "packages" =>{}
}

# bind-utilsはdig,nslookup
base = ["epel-release","yum-utils","xz","wget","traceroute","zip","unzip","bind-utils","libevent2-devel","ncurses-devel","gcc","gcc-c++","gnutls-devel","ntpdate"]

nested = {}
base.each_with_index do |ele1,ind1|
  nested[ind1+1] = ele1
end
data["packages"]["base"] = nested


epel = ["bash-completion"]
nested = {}
epel.each_with_index do |ele1,ind1|
  nested[ind1+1] = ele1
end
data["packages"]["epel"] = nested

ius = ["git2u"]
nested = {}
ius.each_with_index do |ele1,ind1|
  nested[ind1+1] = ele1
end
data["packages"]["ius"] = nested

puts JSON.pretty_generate(data);
