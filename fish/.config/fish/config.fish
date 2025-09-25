#function fish_greeting
#    echo Welcome to ROBCO Industries \(TM\) Termlink
#    echo The time is (set_color yellow; date +%T;set_color normal) and this machine is called $hostname
#end


# function fish_user_key_bindings
# 	fzf_key_bindings
# end


if status is-interactive
    # Commands to run in interactive sessions can go here
end

export MANPAGER="nvim +Man!"

alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# alias neofetch='neofetch --ascii ~/.config/neofetch/pentagram.txt'
alias neofetch='fastfetch'
alias wifi=nmtui
alias dng='WINEPREFIX="$HOME/wine-dng" wine "$HOME/wine-dng/drive_c/Program Files/Adobe/Adobe DNG Converter/Adobe DNG Converter.exe"'
alias so='source ~/.config/fish/config.fish'
alias bat='bat --theme=ansi'

# photo edit automations
alias korkort='~/.dotfiles/scripts/korkort.sh'

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
