#!/bin/bash

# Note, for all other implementations, please add function call "iterateIndex()"

# Globals - ew
WALLPAPER_INDEX_FILE=/tmp/wallpaperIndex  
INDEX=0
FILES=()

function iterateIndex(){
	if [ $INDEX -gt ${#FILES[@]} ];then
		echo "Length of array = ${#FILES[@]}"
		let INDEX=0 

	else
		((INDEX++))
	fi
	echo "$INDEX" > "$WALLPAPER_INDEX_FILE" 
}

if [ ! -f "$WALLPAPER_INDEX_FILE" ]; then
	echo 0 > "$WALLPAPER_INDEX_FILE"
	INDEX=0

else
	read -r INDEX < "$WALLPAPER_INDEX_FILE"
fi

echo "INDEX IS $INDEX"



# I stole this from catWallpaper.sh
if [ "$#" -gt 0 ]; then # parse user argument for custom implementations according to specific desktop environments or window managers. This came about because im using noctalia
	
	if [ -d $1 ]; then
		search_dir=$1
		for entry in "$search_dir"/*
		do
			FILES+=("$entry")
		done

		
		user_arg=$(echo $2 | tr '[:upper:]' '[:lower:]') 
		case $user_arg in

			'noctalia')
				iterateIndex
				noctalia msg wallpaper-set "${FILES[$INDEX]}"
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
