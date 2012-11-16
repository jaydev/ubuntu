# Instructions: http://www.mikeyboldt.com/2011/11/30/install-emacs-24-in-ubuntu/
# Build notes here: https://launchpad.net/~cassou/+archive/emacs
execute "install add-apt-repository" do
  command "apt-get --assume-yes install python-software-properties"
  user "root"
  not_if "which emacs"
end

execute "add emacs ppa" do
  command "add-apt-repository ppa:cassou/emacs"
  user "root"
  not_if "which emacs"
end

execute "update apt" do
  command "apt-get update"
  user "root"
  not_if "which emacs"
end

%w{emacs24 emacs24-el emacs24-common-non-dfsg}.each do |pkg|
  package pkg do
    action :install
    not_if "which emacs"
  end
end
