#!/bin/bash
#
# Install script for my default packages and configs
# by Conny Holm 2024

packages=(
	"alacritty"
	"neofetch"
	"neovim"
	"qtile"
	"rofi"
	"zsh"
	"qt5ct"
	"i3lock"
	"python-iwlib"
	"ttc-iosevka"
	"eza"
	"networkmanager"
	"stow"
)

configs=(
	"alacritty"
	"git"
	"neofetch"
	"nvim"
	"qtile"
	"rofi"
	"fish"
)

# INSTALL PACKAGES
echo -e 'Installing packages:'
installCommand="sudo pacman -S --needed "
for str in ${packages[@]}; do
	installCommand+=$str" "
done
echo $installCommand
# $installCommand

# STOW DOTFILES
echo -e "\nCreating symlinks for configs:"
for str in ${configs[@]}; do
	echo stow $str
	stow $str
done
#
# SET ENVIRONMENT VARIABLES
echo -e '\nManual steps:'
echo -e 'Add QT_QPA_PLATFORMTHEME=qt5ct to /etc/environment'


