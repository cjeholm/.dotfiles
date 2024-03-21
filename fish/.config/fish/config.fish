if status is-interactive
    # Commands to run in interactive sessions can go here
end

export MANPAGER="nvim +Man!"


alias tetris=tint
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# alias neofetch='neofetch --ascii ~/.config/neofetch/pentagram.txt'
alias neofetch='env SHELL=fish neofetch'
alias ls=eza
alias wifi=nmtui
alias tree='eza -la --tree --git --ignore-glob .git'
alias dng='WINEPREFIX="$HOME/wine-dng" wine "$HOME/wine-dng/drive_c/Program Files/Adobe/Adobe DNG Converter/Adobe DNG Converter.exe"'

starship init fish | source
