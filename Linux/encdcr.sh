USAGE="Usage: encrdcr.sh <-e | -d> <target_file> [output_path]"
NOTE="Note: if the output path is left empty, the file will be encrypted/decrypted in the same directory as the target file"

if [ $# -lt 2 ] || [ $# -gt 3  ]; then

	echo "Incorrect argument amount. 2-3 arguments were expected but $# were passed"
	echo $USAGE
	echo ""
	echo $NOTE

else
	# check first arg correctness

	# check second arg correctness
	
	if [ -f $2 ]; then
		case $1 in
			-e | -E)
				if [ $# -ne 3 ]; then
					openssl aes-256-cbc < $2  > $2.aes
				else
					openssl aes-256-cbc < $2  > $3.aes
				fi
				;;

			-d | -D)
				if [ $# -ne 3 ]; then
					openssl aes-256-cbc -d < $2 > $2.unencrypted
				else
					openssl aes-256-cbc -d < $2 > $3.unencrypted
				fi
				;;
		
		*)
			echo "Incorrect flag passed."
			echo $USAGE
			echo ""
			echo $NOTE
		esac
	else
		echo "$2 does not exist. Make sure the path and/or filename is correct."
	fi
fi
