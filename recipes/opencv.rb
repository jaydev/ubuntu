opencv_version = "2.4.1"
home_dir = "/home/vagrant"
opencv_dir = "#{home_dir}/OpenCV-#{opencv_version}"

execute "update apt" do
  command "apt-get update"
  user "root"
  not_if "python -c 'import cv'"
end

%w{
build-essential
libgtk2.0-dev
libjpeg-dev
libtiff4-dev
libjasper-dev
libopenexr-dev
cmake
python-dev
python-numpy
python-tk
libtbb-dev
libeigen2-dev
yasm
libfaac-dev
libopencore-amrnb-dev
libopencore-amrwb-dev
libtheora-dev
libvorbis-dev
libxvidcore-dev
libx264-dev
libqt4-dev
libqt4-opengl-dev
sphinx-common
libv4l-dev
libdc1394-22-dev
libavcodec-dev
libavformat-dev
libswscale-dev}.each do |pkg|
  package pkg do
    action :install
    not_if "python -c 'import cv'"
  end
end

execute "download opencv" do
  command "wget http://downloads.sourceforge.net/project/opencvlibrary/" \
    "opencv-unix/#{opencv_version}/OpenCV-#{opencv_version}.tar.bz2 "
  cwd home_dir
  creates "#{opencv_dir}.tar.bz2"
  user "vagrant"
  not_if "python -c 'import cv'"
end

execute "untar opencv" do
  command "tar xvf #{opencv_dir}.tar.bz2 -C #{home_dir}"
  user "vagrant"
  not_if "python -c 'import cv'"
end

execute "make opencv build directory" do
  command "mkdir -p build"
  cwd opencv_dir
  user "vagrant"
  not_if "python -c 'import cv'"
end

execute "compile opencv" do
  command "cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D " \
    "WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON " \
    "-D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON .."
  cwd "#{opencv_dir}/build"
  user "vagrant"
  not_if "python -c 'import cv'"
end

execute "make and install opencv" do
  command "sudo make install"
  cwd "#{opencv_dir}/build"
  user "root"
  not_if "python -c 'import cv'"
end

execute "add opencv lib path to system config" do
  command "echo /usr/local/lib >> /etc/ld.so.conf.d/opencv.conf"
  user "root"
  creates "/etc/ld.so.conf.d/opencv.conf"
  not_if "python -c 'import cv'"
end

execute "clean up opencv build files" do
  command "rm -rf #{opencv_dir} #{opencv_dir}.tar.bz2"
  cwd home_dir
  not_if "python -c 'import cv'"
end
