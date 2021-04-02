#!/bin/bash

# Executes all arguments as a single command on every server listed in /vagrant/servers file by default.
# -f FILE allows user to override default file of /vagrant/servers. Can create own list of servers execute commands agains that list.
# -n Allows user to perform a 'dry run' where commands will be displayed instead of executed.
# -s run with sudo/root privileges
# -v Enable verbose mode displaying name of server for which command is being executed on.
# Script to be executed without root privileges. You can run commands with root with -s option.
# Provide usage statement and return exit tstatus of 1 if user does not supply a command to run on cmd line or types command incorrectly. Messages within this event will be displayed in standard error.
# Inform user if command was not able to be executed successfully on a remote host.
# Exit with status of 0 of ssh command.

# A list of servers, one per line.
SERVER_LIST='/vagrant/servers'

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2' #Makes sure if host is down, script does not hang for more than 2 seconds per down server.

usage(){
	# Display usage and exit.
	echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
	echo 'Executes COMMAND as a single command on every server.' >&2 
	echo " -f FILE Use FILE for the list of servers. Default: ${SERVER_LIST}" >&2
	echo ' -n      Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
	echo ' -s      Execute the COMMAND using sudo on the remote server.' >&2
	echo ' -v      Verbose mode. Display server name before executing COMMAND.' >&2
	exit 1 		
}

# Make sure script is NOT being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
	then
		echo "Do not execute this script as root or with sudo. Use the -s option instead." >&2
		usage				
fi

# Parse the options

while getopts f:nsv OPTION
do
	case ${OPTION} in
		f) SERVER_LIST="${OPTARG}" ;;
		n) DRY_RUN='true' ;;
		s) SUDO='sudo' ;;
		v) VERBOSE='true' ;;
		?) usage ;;
	esac
done

# Remove the options while leaving remaining arguments.
shift "$(( OPTIND - 1 ))"

# If user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
	then
		usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Make sure the SERVER_LIST file exists.
if [[ ! -e "${SERVER_LIST}" ]]
	then
		echo "Cannot open server list file ${SERVER_LIST}" >&2
		exit 1
fi

# Expect the best, prepare for the worst.
EXIT_STATUS='0'

# Loop through the SERVER_LIST
for SERVER in $(cat ${SERVER_LIST})
do
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${SERVER}"
	fi

	SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

# If it's a dry run, don't execute anything, just echo it.
	if [[ "${DRY_RUN}" = 'true' ]] 
	then
		echo "DRY RUN: ${SSH_COMMAND}"
	else
		${SSH_COMMAND}
		SSH_EXIT_STATUS="${?}"

# Capture any non-zero exit status from the SSH_COMMAND and report to the user
	if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
	then
		EXIT_STATUS=${SSH_EXIT_STATUS}
		echo "Execution on ${SERVER} failed." >&2
	fi
	fi
done

exit ${EXIT_STATUS} 	
# Not exit 0, as if we scan multiple servers and we get an error it will end on that servers error. With this command, we can continue executing this command on all servers available. 
					
  
