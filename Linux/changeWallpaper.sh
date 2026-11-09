#!/bin/bash

# Note, for all other implementations, please add function call "iterateIndex()"

# Globals - ew
WALLPAPER_INDEX_FILE=/tmp/wallpaperIndex  
INDEX=0
FILES=()
RANDOM_INDEX=2


#echo "Arguments: $@" # use this to debug args
#echo "Arg len $#"

function iterateIndex(){
	if [ $INDEX -gt ${#FILES[@]} ];then
		let INDEX=0 

	else
		((INDEX++))
	fi
	echo "$INDEX" > "$WALLPAPER_INDEX_FILE" 
}

function randomIndex(){
	min=1
	max=${#FILES[@]} 
	RANDOM_INDEX=$(awk -v min="$min" -v max="$max" 'BEGIN { srand(); print int(min + rand() * (max - min + 1)) }')
	echo "$RANDOM_INDEX" > "$WALLPAPER_INDEX_FILE"
}

if [ ! -f "$WALLPAPER_INDEX_FILE" ]; then
	echo 0 > "$WALLPAPER_INDEX_FILE"
	INDEX=0

else
	read -r INDEX < "$WALLPAPER_INDEX_FILE"
fi

# I stole this from catWallpaper.sh
if [ "$#" -gt 0 ]; then # parse user argument for custom implementations according to specific desktop environments or window managers. This came about because im using noctalia
		
	if [ -d $1 ]; then
		search_dir=$1
		for entry in "$search_dir"/*
		do
			FILES+=("$entry")
		done

		
		user_arg=$(echo $2 | tr '[:upper:]' '[:lower:]') 
		
		if [ $# -gt 1 ]; then
			case $user_arg in
				
				'noctalia')

					if [ $# -gt 2 ]; then
						randomIndex	
						noctalia msg wallpaper-set "${FILES[RANDOM_INDEX]}" > /tmp/changeWallpaper.log
					else
						iterateIndex
						noctalia msg wallpaper-set "${FILES[$INDEX]}"
					fi
					;;

				*)
					echo "$user_arg is not a known desktop environment/window manager. Please add the implementation to the case branches."
					;;
			esac
		else
			DE=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

			case $DE in
				'hyprland')
					echo "Hyprland branch unimplemented"
					;;

				*)
					echo "$DE is not a known desktop environment. Please add the implementation to the case branches."
					;;
			esac
		fi
	fi
	else
		echo "Error: couldnt find path \"$1\""

	echo "tf"
fi 
