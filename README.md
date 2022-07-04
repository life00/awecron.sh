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
 * change the environment variables in `main.sh`
 * duplicate the template directory in the repo
 * configure the cronjob config as you wish
 * run main.sh as root like a daemon

### Files

 * `bin` is a binary or a shell script that supposed to run
 * `timer` is an essential file that is automatically changed after last run to when the next time the `bin` will run
 * `config` contains configuration variables for the cronjob
    * `name` optional name for logs
    * `user` what user runs the `bin`
    * `intr` interval in seconds

## How it works?

When awecron runs it checks and runs through every directory in the repo (_except dotdirs_). It checks if the current time is more than the next run time in `timer` of the selected cronjob, if yes then it will run the `bin` and set the next run time.

Note: Ignore dotdirs feature is useful when modifying the cronjob to prevent unexpected awecron errors.



