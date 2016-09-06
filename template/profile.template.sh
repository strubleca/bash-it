#!/bin/sh
###############################################################################
# profile.template.sh
#
# Description:
#     Simple template for .profile to be shared between bash and sh
#     environments. This should be limited to environment setup and 
#     sh compatible functions needed in login shells.
###############################################################################

# Reset the path to the system default
unset PATH
if [ -x /usr/libexec/path_helper ]; then
    # On OS X systems, but also others if they implement path_helper
    eval `/usr/libexec/path_helper -s`
else
    # On other Linux/Unix systems
    export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
fi
