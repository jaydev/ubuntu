home_dir = "/home/vagrant"
dotfiles_dir = "#{home_dir}/src/dotfiles"

%w(zsh ack).each do |pkg|
  package pkg do
    action :install
  end
end

execute "change ownership of src directory" do
  command "chown vagrant #{home_dir}/src"
  user "root"
end

git "clone dotfiles" do
  repository "git://github.com/jaydev/dotfiles.git"
  reference "master"
  destination dotfiles_dir
  action :sync
  user "vagrant"
end

symlinks = {
  '.zshrc' => 'zsh/.zshrc',
  '.zprofile' => 'zsh/ubuntu/.zprofile',
  '.gitignore' => 'git/.gitignore',
  '.gitconfig' => 'git/.gitconfig',
  '.ackrc' => '.ackrc',
  '.dir_colors' => '.dir_colors',
  '.virtualenvs/postactivate' => '.virtualenvs/postactivate',
  '.ipython/ipythonrc' => 'python/ipythonrc',
  '.ipython/ipy_user_conf.py' => 'python/ipy_user_conf.py'}

symlinks.each do |target, to|
  link "symlink #{target}" do
    target_file "#{home_dir}/#{target}"
    to "#{dotfiles_dir}/#{to}"
  end
end
