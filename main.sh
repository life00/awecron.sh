#!/bin/bash

REPO=/home/user/awecron
USER=user

# lists all dirs in the repo into an array except dotdirs
# this could be useful when modifying something and preventing unexpected execution 
function exedir() {
	# gets the inputed string
	while read -r -d $'\0' line; do
		# puts into an array
		arr+=("$line")
	done < <(find $REPO/*/ -maxdepth 0 -regextype posix-egrep -regex '.*' -print0) # inputs the string
}

function main() {

	exedir

	# runs in folders in the repo
	for i in ${arr[@]}; do
		
		everytime=$(cat $i\everytime)
		nextrun=$(cat $i\nextrun)
		rootperms=$(cat $i\rootperms)
		currenttime=$(date +%s%N | cut -b1-10)

		if (( $nextrun <= $currenttime )); then
			if [[ $rootperms -eq true ]]; then
				# it is expected for script to be run as root
				doas .$i\script
			else 
				doas -u $USER .$i\script
			fi
			
			echo $(( $currenttime + $everytime )) > $i\nextrun
		fi
	done
	
	# cleaning the array
	exedir=()
}


# just to make sure, it is essential for script/binary execution
cd /

while true; do
	main
	sleep 60
done	


