# Awesome Cron .sh

## Introduction

Awecron is a small and simple custom cron written in POSIX shell script. The aim of this project is to create a minimal cron in POSIX shell script with a special scheduling design for desktop / laptop users. Awecron was written expecting users to fully understand how it works and be able to debug it on the source code level if necessary.

Note however that you are encouraged to instead use the awecron implementation written in Golang as it is arguably more suitable for the application, has better error checks and appears to have better performance. You may find it in [this repository](https://github.com/life00/awecron). It is _fully_^[Except the global awecron config [./cfg](./cfg) in awecron.go is a TOML file, not a shell script like in awecron.sh. This however is not a problem because as long as you keep it simple like in the example provided (i.e. don't run actual shell scripts) it is cross compatible. This is the reason why TOML was chosen for awecron.go.] compatible with the existing awecron.sh configuration.

### Features

- uses the [special cronjob scheduling design](#scheduling-design) for desktop / laptop users
- very minimal and small
- POSIX compliant (i.e. you can _probably_ also run it on macOS, FreeBSD, OpenBSD, etc.)
  - also this means that its possible to use dash or ash and benefit from high performance
- runs cronjobs in parallel
- performs error checking on initialization
- has timeout feature
  - will force stop a cronjob if it exceeds the set time limit
- has dynamic sleep feature
  - runs `sleep` for the exact time needed until next cronjob
- if cronjob errors then it is automatically disabled

## Installation

### Compatibility

Should work on any POSIX compliant system. Tested on:

- Alpine Linux (BusyBox) with ash
- Fedora Linux (GNU coreutils) with dash

### Setup

1. clone the repo: `git clone https://github.com/life00/awecron`
2. delete all unnecessary files: `rm -rfv ./awecron/.git`
   - you may also remove the rest later
3. move the binary to an appropriate location: `mv ./awecron/awecron /usr/local/bin/`
4. move the config directory to an appropriate location: `mv ./awecron /etc/`
5. ensure that the permissions are set appropriately: `chown root:root /usr/local/bin/awecron /etc/awecron; ...`
6. verify validity of all files
7. configure awecron (see [configuring awecron section](#configuring-awecron))
8. run awecron (see [running awecron section](#running-awecron))

#### Configuring awecron

When the awecron is run it first tries to check if the configuration directory is in `$XDG_CONFIG_DIR/awecron/` or `$HOME/.config/awecron/`, then it checks the global configuration in `/etc/awecron/`. The former should be used when running awecron as non root user (see below).

The global configuration of awecron is a shell script located in [./cfg](./cfg). See the comments there for details.

There is a simple cronjob configuration example in [./ex/](./ex/). It includes the following files:

- `run` is a binary or a shell script that supposed to run
- `tmr` is an empty file; its last modification time is used to determine the next run time of a cronjob
  - without the file awecron will ignore the directory
- `cfg` contains the interval the cronjob should run at

#### Running awecron

You may use the following simple examples of init service configuration for awecron (see [./sf/](./sf/) directory):

- [OpenRC](./sf/openrc/awecron)
- [runit](./sf/runit/)
- [systemd](./sf/systemd/awecron.service)

Awecron runs all the cronjobs as its current user. As previously mentioned it is possible to have the configuration of awecron in the local user environment. This way you may have multiple instances of awecron running as different users without interference.

## Design choices

### Scheduling design

As it was already stated the design has desktop / laptop users in mind. The problem with these platforms may be that they could be offline most of the time, and as the result the cronjob schedules are inconsistent and may be missed regularly. When using crontab the issue may be that the cronjob is skipped at that specific time (e.g. 12:00) because the device could be offline. In these cases anacron is suggested, however it still has a similar problem that the next scheduled time might be the time when the device will be offline, thus skipping the cronjob.

Similarly to anacron, awecron also periodically runs cronjobs, however awecron solves the above-mentioned problem by running skipped cronjobs as soon as possible instead of waiting for the next scheduled time, then rescheduling them based on the interval. This is the key difference of awecron and why I believe it is most suitable for desktop / laptop users.

### Implementation design

I have chosen to write it in POSIX shell script as a way to improve my shell script knowledge. Awecron was strongly inspired by the runit init system and its design choices. It is similarly a POSIX shell script, very minimal, and has similar features of handling runtime resources and configuration files.

Awecron script will first determine its config directory where all the runtime files and configuration are stored, and then perform initial error checking. Then it will run through all directories in the config directory which contain `tmr` file (`$cdir/*/tmr`) which it assumes are cronjobs.

All cronjobs run in parallel with a separate subshell. Awecron checks if its necessary to run the cronjob and if yes then it runs the binary (`$cdir/*/run`) and also spawns a timeout watchdog process that ensures the cronjob does not exceed the time limit (configured in global awecron config).

After the cronjob is successful the next run time is calculated from the cronjob interval configuration (`$cdir/*/cfg`) and saved as last modification time of `tmr` file (`$cdir/*/tmr`).

In case the cronjob fails the `tmr` file is not created and so the cronjob is disabled. This may especially be useful when manually disabling a cronjob (e.g. `rm "$cdir/ex/tmr"`) or making it run as soon as possible (e.g. `touch "$cdir/ex/tmr"; systemctl restart awecron`).

When a cronjob is run the appropriate logs are outputed containing the user that runs awecron (and the cronjob), name of the cronjob (directory), exit code, and log message.

Afterwards, awecron runs dynamic sleep function which calculates the necessary amount of time to sleep until the next cronjob. This allows awecron to be very efficient and mostly be in the background. It is possible to also configure the maximum and minimum time limits of sleep in global awecron config. This may be useful to reduce possible overhead of small interval cronjobs (minumum limit) and make awecron check for newly added or updated cronjobs more frequently (maximum limit). In between sleep intervals awecron runs and checks all the necessary cronjobs and reevaluates its next optimal sleep time.

## To-Do

- [x] rewrite awecron in Golang
  - see the [repository](https://github.com/life00/awecron)

## Credits

Special thanks to these guys:

- [hello-smile6](https://github.com/hello-smile6) for creating a mirror of the repo and other contributions
- [inferenceus](https://github.com/inferenceus) for fixing my bad English
- [kurahaupo](https://github.com/kurahaupo) for suggesting significant improvements to the code
