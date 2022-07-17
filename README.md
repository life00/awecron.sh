### Note: Awecron requires root privileges and written by random guy on the internet. Understand the risks before using it.

# Awesome Cron
## Introduction
Awecron is a small and simple custom cron that has something similar between anacron and crontab.
The main use case for it is for desktop users however nothing limits using it on a server.

### The advantages of using it:
 * extremely minimal and easy to read
 * would still run if misses cronjob run time (_if comparing with crontab_)
 * no complicated time logic (_if comparing with anacron and using on desktop_)

## Installation

### Dependencies

* sudo / opendoas
* bash
* GNU date


### How to use? 

 * clone the repo
 * delete all hidden directories
 * change the configurable environment variables in `main.sh`
 * configure the cronjob inside of template directory as you wish
 * make sure permissions are set securely to prevent privilege escalation
 * run main.sh as root like a daemon

### Files

 * `bin` is a binary or a shell script that supposed to run
 * `timer` is an essential file that is automatically changed after last run to when the next time the `bin` will run
 * `config` contains configuration variables for the cronjob
    * `name` optional name for logs
    * `user` what user runs the `bin`
    * `intr` interval in seconds

## How it works?

When awecron runs it checks and runs through every directory in the repo. It checks if the current time is more than in `timer` file of the selected cronjob, if yes then it will run the `bin` and set the `timer` again.
