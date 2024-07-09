if status is-interactive
    # Commands to run in interactive sessions can go here
end

export MANPAGER="nvim +Man!"

alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# alias neofetch='neofetch --ascii ~/.config/neofetch/pentagram.txt'
alias neofetch='env SHELL=fish neofetch'
alias wifi=nmtui
alias dng='WINEPREFIX="$HOME/wine-dng" wine "$HOME/wine-dng/drive_c/Program Files/Adobe/Adobe DNG Converter/Adobe DNG Converter.exe"'
alias nv='steam-run nvim'
alias so='source ~/.config/fish/config.fish'

# ls / eza
alias tree='eza --tree --icons --group-directories-first'
alias treell='eza -la --tree --git --ignore-glob .git'
alias ll='eza -la'

# copy path
alias xc='pwd | xsel -ib'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# nix-your-shell stuff
if command -q nix-your-shell
  nix-your-shell fish | source
end

starship init fish | source
