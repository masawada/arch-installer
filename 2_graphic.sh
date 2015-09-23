# install graphic driver
yaourt xf86-video-intel

# install awesome
yaourt xorg-server xorg-xinit xorg-utils xorg-server-utils xterm awesome

# init scripts
cp /etc/skel/.xinitrc $HOME/
echo "exec awesome" >> $HOME/.xinitrc
mkdir -p $HOME/.config/awesome/
cp /etc/xdg/awesome/rc.lua $HOME/.config/awesome/

cat <<EOF > /etc/X11/xorg.conf.d/10-monitor.conf
Section "Monitor"
  Identifier "MainMonitor"
  Option "PreferredMode" "1280x800"
EndSection

Section "Device"
  Identifier "Device0"
  Driver "modesetting"
  Option "monitor-VGA" "MainMonitor"
EndSection

Section "Screen"
  Identifier "Screen0"
  Device "Device0"
  Monitor "MainMonitor"
  DefaultDepth 24
  SubSection "Display"
    Depth 24
  EndSubSection
EndSection
EOF
