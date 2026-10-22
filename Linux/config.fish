source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end


alias cls="clear"
alias editFish="nano ~/.config/fish/config.fish"
alias editFishVIM="nvim ~/.config/fish/config.fish"
alias refresh="source ~/.config/fish/config.fish"
alias bedTime="~/Code/MassScripts/Linux/bedtime.sh"
alias newKitty="~./Code/MassScripts/Linux/catWallpaper.sh"
alias encdcr="~/Code/MassScripts/Linux/encdcr.sh"
alias getGitKey='~/Code/MassScripts/Linux/encdcr.sh -d ~/gitKey.aes && cat ~/gitKey.aes.unencrypted | wl-copy && rm ~/gitKey.aes.unencrypted'
alias GPUUSAGE="nvidia-smi --loop=1"
alias updatePackages="sudo pacman -Syyu"
alias cleanSystem="sudo pacman -Rns (pacman -Qdtq)"
alias getDefaultGateway="ip r | grep ^def"
alias editBinds="nvim ./.config/hypr/hyprland.lua"
alias editBindsLegacy="nvim ./.config/hypr/hyprland.conf"
alias flushClipboard="echo | wl-copy"
alias pushToGit="getGitKey && git push && flushClipboard"
alias timer="~/Code/Alarm/build/Alarm"
alias gitList="git ls-files . --exclude-standard --others"
alias updateTrackedConfig="cp -i ~/.config/fish/config.fish ~/Code/MassScripts/Linux/"
