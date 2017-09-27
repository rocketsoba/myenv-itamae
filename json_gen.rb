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
    "name" => "vagrant",
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

ius = ["git2u", "httpd24u"]
nested = {}
ius.each_with_index do |ele1,ind1|
  nested[ind1+1] = ele1
end
data["packages"]["ius"] = nested

remi56 = ["php-cli" "php-fpm" "php-pdo" "php-mysqlnd", "php-intl", "php-mbstring", "php-xml", "mysql", "mysql-server"]
nested = {}
remi56.each_with_index do |ele1,ind1|
  nested[ind1+1] = ele1
end
data["package"]["remi56"] = nested

# remi_without_ius = ["phpMyAdmin"]
# nested = {}
# remi_without_ius.each_with_index do |ele1,ind1|
#   nested[ind1+1] = ele1
# end
# data["package"]["remi_without_ius"] = nested

puts JSON.pretty_generate(data);
