# Git-Org #

A utility that syncs files in a Git repo automatically. It is meant as
a simple dropbox replacement for relatively small collections of
(text) files.

The program will detect changes and automatically push them to the
remote, and it will periodically pull new changes from the remote.

Any conflicts will need to be handled by yourself, so you should be
able to handle merge/rebase conflicts.

I use it to automatically synchronize my org-mode files. It has been
tested with Mac OS and Linux, and should run fine under WSL for
Windows.

The script is loosely based on [git-sync](https://github.com/simonthum/git-sync) and [gitwatch](https://github.com/gitwatch/gitwatch).


# Dependencies

## Linux
On Linux you need the `inotifywait` command to be available, which
means you might need to install a package called something like
inotify-tools.

## Mac OS

For Mac OS you need:

- [coreutils](https://www.gnu.org/software/coreutils/coreutils.html)
- [fswatch](https://emcrisostomo.github.io/fswatch/)

I would advice to use Homebrew to install those.


# Your repo

You should have a git repo set up somewhere, with a branch checked out
that has an upstream branch configured.

If you just clone an existing repo, that will work.

# Get started ##

Download the script, put it on your PATH and point it to your repo:

``` shell
git org path-to-the-repo
```

# What does it do?

When you make changes in your repo, the script will detect this. It
will wait for a minute and then commit and push.

Every 10 minutes the script will fetch any incoming changes from the
remote. If necessary, your new changes will be rebased on top of the
incoming changes.

In case of merge or rebase conflicts, the script will show a warning
and leave it to you to solve these conflicts.

Tf you add more than 1000 kilobytes of data at once, or more than 10
new files, the script will

# Options

- `-h`: Shows a help page
- `-q`: Don't show system notifications (e.g. notify-send)
- `-1`: Run once, return immediately
- `-s`: Specify the number of seconds to wait before commit when a change is detected. Default 1 minute.

# Configuration

To configure some of the scripts behaviour you will have to edit it.
The following variables are declared at the top:

- `TIMEOUT`: how long to wait between fetch operations. Default: 10 minutes.
- `SLEEP_BEFORE_COMMIT`: how long to wait before commit, when a change is detected. Default: 1 minute. Can also be set through `-s` switch.

The following are to prevent accidentally adding lots of data. If you
add more than these limits, the script will refuse to push and you
will have to do it manually.

- `MAX_NEW`: max number of new files to commit. 
- `MAX_NEW_SIZE`: 1000: max size of new files (in kilobytes)

# Branches

The script does not care about branches; it always pushes/pulls the currently checked out branch to/from its upstream.
