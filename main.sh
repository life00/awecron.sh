#!/bin/bash
# Note: the code is very commented for convenience and newbies (not to annoy)

# configurable environment variables
REPO=/home/user/awecron/ # location of the repo
SUDO=sudo # option to choose between sudo or doas

function main() {
	# runs through all directories in the $REPO
        for i in "$REPO"/*/; do
                # gets the cronjob configuration variables
                source "$i/config"
		# compares the timer with the current time
		timer=$(cat "$i/timer")
		time=$(date +%s%N | cut -b1-10)
                if (( timer <= time )); then
                        # logs events
        		printf "awecron ${user}: ${name}\n"
                        # runs the binary with specified user
                        $SUDO -u $user "$i/bin"
                        # sets the timer
                        echo $(( time + intr )) > "$i/timer"
                fi
        done
        # cleans the array
        arr=()
}

while true; do
        main
	# frequency of cron 
        sleep 60
done
