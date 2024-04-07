#!/bin/bash
#
# Install script for my default packages and configs
# by Conny Holm 2024

packages=(
)

configs=(
	"alacritty"
	"fish"
	"git"
	"neofetch"
	"nvim"
	"qtile"
	"rofi"
)

# INSTALL PACKAGES
# echo -e 'Installing packages:'
# installCommand="sudo pacman -S --needed "
# for str in ${packages[@]}; do
# 	installCommand+=$str" "
# done
# echo $installCommand
# $installCommand

# STOW DOTFILES
echo -e "\nCreating symlinks for configs:"
for str in ${configs[@]}; do
	echo stow $str
	stow $str
done

# SET ENVIRONMENT VARIABLES
# echo -e '\nManual steps:'
# echo -e 'Add QT_QPA_PLATFORMTHEME=qt5ct to /etc/environment'


