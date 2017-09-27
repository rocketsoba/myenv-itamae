# coding: utf-8
if node["platform"] != "redhat" && node["platform_version"].to_i != 6 then
  exit(1)
end

execute "update yum repo" do
  user "root"
  command "yum -y update"
end

if node["userdata"]["flag"] == 1 then
  user node["userdata"]["name"] do
    password node["userdata"]["password"]
    not_if "id -a #{node["userdata"]["name"]}"
  end
end

execute "usermod -aG wheel #{node["userdata"]["name"]}" do
  not_if "groups #{node["userdata"]["name"]} | grep wheel"
end
  
template "/etc/sudoers" do
  source "templates/sudoers"
  mode   "440"
  owner  "root"
  group  "root"
end

# テンプレートリソースはroot外のユーザでやるとエラーになる
template "/home/#{node["userdata"]["name"]}/.bash_profile" do
  owner node["userdata"]["name"]
  group node["userdata"]["name"]
  source "templates/.bash_profile"
end

directory "/home/"+node["userdata"]["name"]+"/.ssh" do
  user node["userdata"]["name"]
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

git "https://github.com/rocketsoba/dotfiles" do
  user node["userdata"]["name"]
  destination "/home/#{node["userdata"]["name"]}/.dotfiles"
  repository "https://github.com/rocketsoba/dotfiles"
end

directory "/home/#{node["userdata"]["name"]}/.emacs.d" do
  user node["userdata"]["name"]
end

execute "initial file deploy" do
  user node["userdata"]["name"]
  command <<-EOH
cp /home/#{node["userdata"]["name"]}/.dotfiles/init.el /home/#{node["userdata"]["name"]}/.emacs.d/init.el
cp /home/#{node["userdata"]["name"]}/.dotfiles/_tmux.conf /home/#{node["userdata"]["name"]}/.tmux.conf
EOH
end

directory "/tmp/work"

execute "build emacs" do
  cwd "/tmp/work/"
  command <<-EOH
if [ ! -e /tmp/work/emacs-25.1.tar.xz ]; then
  wget "http://ftp.jaist.ac.jp/pub/GNU/emacs/emacs-25.1.tar.xz"; 
fi

if [ ! -d /tmp/work/emacs-25.1 ]; then
  tar xf emacs-25.1.tar.xz;
fi

cd emacs-25.1

if [ ! -d /home/#{node["userdata"]["name"]}/opt/emacs ]; then
  source scl_source enable devtoolset-3;
  ./configure --prefix=/home/#{node["userdata"]["name"]}/opt/emacs;
  make -j4;
  make install;
fi
EOH
  not_if "env PATH=$PATH:$HOME/bin:/home/#{node["userdata"]["name"]}/opt/emacs/bin:/home/#{node["userdata"]["name"]}/opt/tmux/bin which emacs"
end

execute "build tmux" do
  cwd "/tmp/work/"
  command <<-EOH
if [ ! -e /tmp/work/tmux-2.3.tar.gz ]; then
  wget "https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz";
fi

if [ ! -d /tmp/work/tmux-2.3.tar.gz ]; then
  tar xf tmux-2.3.tar.gz;
fi
cd tmux-2.3
if [ ! -d /home/#{node["userdata"]["name"]}/opt/tmux ]; then
  source scl_source enable devtoolset-3;
  ./configure --prefix=/home/#{node["userdata"]["name"]}/opt/tmux;
  make -j4;
  make install;
fi
EOH
  not_if "env PATH=$PATH:$HOME/bin:/home/#{node["userdata"]["name"]}/opt/emacs/bin:/home/#{node["userdata"]["name"]}/opt/tmux/bin which tmux"
end

node["packages"]["vmtools"].each do |ele1|
  package ele1[1]
end


# directory "/tmp/work" do
#   action :delete
# end


