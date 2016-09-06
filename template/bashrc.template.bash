#!/usr/bin/env bash
###############################################################################
# bashrc.template.bash
#
# Description:
#     This is a template for .bashrc files. The .bashrc file is read by
#     interactive, non-login shells in a default BASH setup. In this custom
#     Bash-it setup, the .bashrc file is sourced by .bash_profile so that
#     it is read by login shells (interactive and non-interactive) as well.
#
#     It is recommended to place most logic in this file, or in files sourced
#     by this file.
#
#     Below are environment variables used to configure the rest of the Bash-it
#     framework.
###############################################################################

# Path to the bash it configuration
export BASH_IT="{{BASH_IT}}"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Set the root directory for customizations, defaulting to $BASH_IT/custom
# This shouldn't need to be an exported environment variable.
# BASH_IT_CUSTOM="/my/bash-it/custom"

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the 
# prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Load Bash It
source $BASH_IT/bash_it.sh
