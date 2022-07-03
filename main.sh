#!/bin/bash

REPO=/home/user/awecron
USER=user

# just to make sure, it is essential for script/binary execution
cd /

function main() {
	# runs in all folders in the repo
	for i in $REPO/*/; do
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
	
}

while true; do
	main
	sleep 60
done	


