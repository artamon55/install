#!/bin/bash

loadkeys ru
setfont cyr-sun16

echo 'Синхронизация системных часов'
timedatectl set-ntp true

echo 'Cоздание разделов'
cfdisk

echo 'Форматирование дисков'
mkfs.ext4  /dev/sda5
mkswap /dev/sda6
mkfs.ext4  /dev/sda7

echo 'Монтирование дисков'
mount /dev/sda5 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda2 /mnt/boot/efi
mount /dev/sda7 /mnt/home

echo 'Выбор зеркал для загрузки.'
rm -rf /etc/pacman.d/mirrorlist
wget https://git.io/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo 'Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd

echo 'Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/Je8iw)"
