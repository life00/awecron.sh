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
 * run main.sh as root like a daemon

### Files

 * `run` is a binary or a shell script that supposed to run
 * `tmr` is an essential file that is automatically changed after last run to when the next time the `run` will run
    * it uses last modification date of the file to set the timer
 * `cfg` contains configuration variables for the cronjob
    * `name` optional name for logs
    * `user` what user runs the `run`
    * `intrv` interval in seconds

## How it works?

When awecron runs it checks and runs through every directory in the repo. It checks if the current time is more than in `tmr` file of the selected cronjob, if yes then it will run the `run` and set the `tmr` again.
