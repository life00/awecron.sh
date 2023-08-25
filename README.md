### Disclaimer: Awecron requires root privileges and written by random guy on the internet. Understand the risks before using it.

# Awesome Cron
## Introduction
Awecron is a small and simple custom cron that has something similar between anacron and crontab.
The aim of this project is to create extremely minimal cron that user is supposed to understand and debug on the source code level.
Awecron was written without considering user experience and expecting users to fully understand how it works.

### The advantages of using it:
 * extremely minimal and easy to read
 * would still run if misses cronjob run time (_if comparing with crontab_)
 * no complicated time logic (_if comparing with anacron and using on desktop_)

## Installation

### Dependencies

* bash
* su
* stat
* touch

#### Tested on:

* GNU coreutils
* BusyBox

### How to use? 

 * clone the repo
 * delete all hidden directories
 * configure the cronjob inside of an example template directory `ex` as you wish
 * make sure permissions are set securely to prevent privilege escalation
 * run `awecron` as root like a daemon

### Files

 * `run` is a binary or a shell script that supposed to run
 * `tmr` is an essential file that is automatically changed after last run to when the next time the `run` will run
    * it uses last modification date of the file to set the timer
 * `cfg` contains configuration variables for the cronjob
    * `user` what user runs the `run`
    * `run` run interval in seconds
    * `talr` *try again later* run interval in seconds

## How it works?

When awecron runs it checks and runs through every directory in the repo. It checks if the current time is more than in `tmr` file of the selected cronjob, if yes then it will run the `run` and set the `tmr` again.

## To-Do

- error handling and optimization
  - [ ] skip and disable cronjob if stuck/frozen
    - error prevention and helps with the time skewing
  - [ ] running cronjobs in parallel or cronjob running priority or cronjob time correction
    - this is important to prevent time skewing for different cronjobs
- creation of supplementary scripts
  - [x] ~~create a separate `debugger` script that will allow the user to check for any errors or issues with awecron configuration, file permissions, etc.~~ Awecron checks for errors on statups
  - [ ] create a miscellaneous cronjob that cleans the logs of awecron 
- other
  - [ ] improve packaging and distribution system
    - currently it is assumed that the user knows what everything does when installing the program, but this is not optimal
    - a better packaging+distribution system will require defining where awecron components will live and how it will be installed
      - using a script (*also not optimal*)
      - using a package manager (*unlikely because complicated*)
    - this will likely be resolved as the user base of awecron will grows
  - [ ] rewrite awecron in Go
    - this would be a rather complicated task considering that a lot of shell script functionality is used
    - this might be implemented for experimental purposes


## Credits

Special thanks to these guys:

- [hello-smile6](https://github.com/hello-smile6) for creating a mirror of the repo and other contribution
- [inferenceus](https://github.com/inferenceus) for fixing my bad English
- [kurahaupo](https://github.com/kurahaupo) for suggesting significant improvements to the code 

