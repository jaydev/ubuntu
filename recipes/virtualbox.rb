home_dir = "/home/vagrant"
vbox_version = "4.2.4"

execute "download latest guest additions" do
  command "wget -c http://download.virtualbox.org/virtualbox/#{vbox_version}" \
    "/VBoxGuestAdditions_#{vbox_version}.iso"
  user "vagrant"
  cwd home_dir
  creates "#{home_dir}/VBoxGuestAdditions_#{vbox_version}.iso"
  not_if "modinfo vboxguest | grep '#{vbox_version}'"
end

execute "unmount" do
  command "umount /mnt"
  user "root"
  only_if "mount | grep VBox"
end

execute "mount guest additions" do
  command "mount VBoxGuestAdditions_#{vbox_version}.iso -o loop /mnt"
  user "root"
  cwd home_dir
  not_if "mount | grep VBox"
  only_if { File.exists? "#{home_dir}/VBoxGuestAdditions_#{vbox_version}.iso" }
end

execute "update apt" do
  command "apt-get update"
  user "root"
  not_if "modinfo vboxguest | grep '#{vbox_version}'"
end

%w{dkms linux-headers-3.2.0-32-generic}.each do |pkg|
  package pkg do
    action :install
    not_if "modinfo vboxguest | grep '#{vbox_version}'"
  end
end

execute "install guest additions" do
  command "sh /mnt/VBoxLinuxAdditions.run"
  user "root"
  not_if "modinfo vboxguest | grep '#{vbox_version}'"
end

execute "clean up iso" do
  command "rm #{home_dir}/VBoxGuestAdditions_#{vbox_version}.iso"
  only_if { File.exists? "#{home_dir}/VBoxGuestAdditions_#{vbox_version}.iso" }
end
