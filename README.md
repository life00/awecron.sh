
## [WARNING] Potential Security Risk
The awecron is supposed to be run as root so you should make sure that the write permissions are set right.
It is recommended to copy the repo contents for installation to not run `git pull` with root privileges.
Also **please** look through the code before you run anything (very simple to read).

# Awesome Cron
This is a small and simple custom cron that has something similar between anacron and crontab.

To use awecron: 

 * change the environment variables in `main.sh`
 * duplicate the template directory in the repo
 * configure as you wish
 * complete all the security recommendations above
 * run main.sh as root like a daemon

## Dependencies

* opendoas (temporary no sudo)


## Files

 * `everytime` contains a string of numbers that represent seconds you want the awecron to execute the script.
 * `nextrun` is an essential file that is automatically changed after execution to when the next time the script will run
 * `rootperms` contains a condition true or false if you want to give the script root perms
 * `script` is a binary or a bash script that you want to execute

**ALL OF THE FILES SHOULD BE IN THOSE NAMES ONLY**


## How it works?

The `nextrun` file contains the next time it would be executed. If the current time is more than that time it was set to execute the script then it will run and add the `everytime` to the current time and put it again into `nextrun` file.
Basically this cron is for desktop usage when you dont want to miss the execution of a script and you dont want to mess around with anacron time logic.

## Work In Progress

Currently awecron is in development but already works so use it on your own risk.
The documentation, functionaly and support is WIP so please be patience.
I am also happy for any contribution and suggestions.
