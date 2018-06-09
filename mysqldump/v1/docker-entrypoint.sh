#!/bin/bash

set -eo pipefail

function _showHelp() {
   # intentionally mixed spaces and tabs here
   # tabs are stripped by "<<-EOF", spaces are kept in the output
   cat >&2 <<-EOF

	Required Variables:

	   {DB_HOST}                Database Address
	   {DB_USER}                Database Username
	   {DB_PASS}                Database Password

	Optional Variables:

	   {DB_NAME}                Database Name
	   {ALL_DATABASES}          Boolean option, yes/no (if DB_NAME empty, this option will be "yes")
	   {IGNORE_DATABASE}        Database name that will ignore in procedure
	EOF
   exit 0
}

function _validadeConfig() {
   # check if all the variable that are required were set
   if [ -z "${DB_HOST}" -o \
        -z "${DB_USER}" -o \
        -z "${DB_PASS}" ]; then
      echo >&2 'ERROR: You need to specify all the variables.'
      _showHelp
      exit 1
   fi
}

if [ "$1" == 'dump' ] || [ "$1" == 'import' ]; then
   _validadeConfig
fi

# If argument is not related, we assume that
# user wants to run his own process, for example
# a "bash" shell to explore this image
exec "$@"