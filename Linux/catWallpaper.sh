#!/bin/bash
# This script is to be intended to hooked into some other script or as a keybind. 
# This automatically changes your wallpaper to a picture of a kitty using the CATAAS API (https://cataas.com/) 

if [ ! -d KITTY ]; then
	mkdir KITTY
fi

timestamp=#$(date +%s)
filename="KITTY/kitty.png${timestamp}"

if type curl &> /dev/null; then #if curl exists on system 

	curl https://cataas.com/cat > $filename

	if [ "$#" -gt 0 ]; then # parse user argument for custom implementations according to specific desktop environments or window managers. This came about because im using noctalia
		user_arg=$(echo $1 | tr '[:upper:]' '[:lower:]') 
		case $user_arg in

			'noctalia')
				noctalia msg wallpaper-set "$filename"
				;;

			*)
				echo "$user_arg is not a known desktop environment/window manager. Please add the implementation to the case branches."
    				;;
		esac
	else
		DE=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

		case $DE in
			'hyprland')
				echo "Unimplemented"
				;;

   			*)
				echo "$DE is not a known desktop environment. Please add the implementation to the case branches."
    				;;
		esac
	fi 
fi
#cleanup

rm -rf KITTY

