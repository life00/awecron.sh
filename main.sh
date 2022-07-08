#!/bin/bash

REPO=/home/user/awecron
SUDO=sudo

# lists all dirs in the repo into an array except dotdirs
# this could be useful when modifying something and preventing unexpected errors
function rundir() {
        # gets the inputed string
        while read -r -d $'\0' line; do
                # puts into the array
                arr+=("$line")
        done < <(find $REPO/* -maxdepth 0 -type d -regextype posix-egrep -regex '.*' -print0) # inputs the string
}

function cronlog() {
	# you can change how log looks below
        printf "awecron ${user}: ${name}\n"
}

function main() {

        rundir

	# runs through everything in the array
        for i in ${arr[@]}; do
                # gets the cronjob configuration variables
                source $i/config

                timer=$(cat $i/timer)

                time=$(date +%s%N | cut -b1-10)

                if (( $timer <= $time )); then
                        cronlog
                        # it is expected for script to run as root
                        $SUDO -u $user $i/bin
                        # setting the next run time
                        echo $(( $time + $intr )) > $i/timer
                fi
        done

        # cleaning the array
        arr=()
}


while true; do
        main
        sleep 60
done
