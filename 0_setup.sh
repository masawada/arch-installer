# ref: http://kunst1080.hatenablog.com/entry/2014/10/19/212305
NEWHOSTNAME=$1
ROOTPASSWD=$2

# Setup disk
mkfs.ext4 /dev/sda1 # /boot
mkfs.ext4 /dev/sda2 # /

# Install base system
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
grep jp /etc/pacman.d/mirrorlist > mirrorlist
cat /etc/pacman.d/mirrorlist >> mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist
yes "" | pacstrap -i /mnt base base-devel
yes "" | pacstrap -i /mnt grub-bios net-tools networkmanager

# Generate fstab
genfstab -p /mnt >> /mnt/etc/fstab

# Create Setup Script on chroot environment
cat <<EOF > /mnt/setup.sh
#!/bin/bash
echo $NEWHOSTNAME >> /etc/hostname

ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf

echo root:$ROOTPASSWD | chpasswd

# network
systemctl enable NetworkManager.service

# generate image
mkinitcpio -p linux

# install grub
grub-install --root-directory=/ /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
EOF

chmod +x /mnt/setup.sh

# Setup chroot environment
arch-chroot /mnt "/setup.sh"

# Finish
umount -R /mnt
reboot
