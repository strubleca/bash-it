#!/usr/bin/env bash
###############################################################################
# bash_profile.template.bash
#
# Description:
#     Template for .bash_profile, which is loaded by login shells. On many
#     Unix systems, this is sourced only for when a user logs into the system,
#     while terminal windows are non-login, interactive shells. On OS X, 
#     however, Terminal defaults to creating login, interactive shells. This
#     creates a lot of confusion in what code to place in which files.
#
#     The design here is to follow suggestions from the following articles:
#
#         https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-\
#         loading-order-bashrc-zshrc-etc/
#
#         http://endoflineblog.com/bash-initialization-files
#
#     This template loads .profile first, if it exists, to allow for sharing
#     of login behavior with sh, which is often desirable. Then, .bashrc
#     is loaded. Most of the logic is placed in .bashrc and any differences
#     for login vs. non-login, and interactive vs. non-interactive are handled
#     in .bashrc.
###############################################################################

# First source .profile
[ -r "${HOME}/.profile" ] && . "${HOME}/.profile"

# Now source .bashrc
[ -r "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
