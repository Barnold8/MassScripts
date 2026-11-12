#!/bin/bash

# Add more partial download file indicators here if its not supported - Note, all in file to avoid packing with config folder for simple scripts
part_temps=(
    ".part" ".crdownload" ".download" ".opdownload" ".partial" ".tmp" ".temp"
    ".ucdl" ".dm" ".qdl" ".filepart" ".dlm" ".netscape" ".ns" ".khtml"
    ".obml" ".idm" ".fdmdownload" ".aria2" ".!qb" ".!ut" ".bc!" ".met"
    ".curl" ".incomplete" ".downloading" ".rsync" ".wget" ".ufinished"
    ".antifrag" ".dctmp" ".gdown" ".dl!" ".jc!" ".jdownload" ".moz"
)
check_dir="$1"
keep_running=true
FILES=()
time_to_shutdown=120
sleep_time=5
partial=false

function _help(){

	echo "USAGE: shutdownAfterDownload.sh [directory | -h] [time_to_shutdown] [sleep_time]
	-h: shows this page
	directory: path to your download directory of choice
	time_to_shutdown: how long to wait before shutting the system down after downloads are complete (in minutes)
	sleep_timer: how long to wait before checking the download directory again (can cut down on disk and cpu usage)"
}

function isNumber(){

	local number=$1

	re='^[0-9]+$'
	if ! [[ $number =~ $re ]] ; then
		return 0
	else
		return 1
	fi
}

if [[ -n "$1" ]] && isNumber "$2"; then
	sleep_time="$1"
fi


# _shutdown to avoid calling shutdown command
function _shutdown(){

	if [[ -n "$1" ]] && isNumber "$1"; then
		time_to_shutdown="$1"
	fi
	echo "Downloads complete! Shutting down in $sleep_time minutes"
	shutdown -P +$sleep_time
}


if [ $# -ge 1 ]; then

    if [ "$1" = "-h" ]; then
    	_help
    elif [ -d "$check_dir" ]; then
    
	while [ "$keep_running" = true ]; do
		
		mapfile -d '' FILES < <(find "$check_dir" -type f -print0)
	
		for FILE in "${FILES[@]}"; do
			EXT=".${FILE##*.}"
			# this weird "if" checks if a substring in the part_temps array exists in the filename
			if [[ " ${part_temps[*]} " == *" $EXT "* ]]; then 
				partial=true
				echo "True with $FILE"
			fi
		done
		if [[ "$partial" = "false" ]]; then

			keep_running=false
		fi
		sleep "$sleep_time"
		partial=false # reset to enforce another check 
	done

	_shutdown "$2" "$3"

    else
        echo "Directory does not exist: $check_dir"
    fi
else
    echo "No arguments passed. Try -h for help"
fi

