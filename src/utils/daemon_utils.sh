#!/bin/bash
# name: daemon_utils.sh
# description: Daemon which can be used by other scripts..
# version: 0.1
# author: rednammoc
#

BASH_UTILS_DIR=${BASH_SOURCE%/*}
if [[ ! -d "$BASH_UTILS_DIR" ]]; then BASH_UTILS_DIR="$PWD"; fi
BASH_UTILS_LOG="${BASH_UTILS_DIR}/log_utils.sh"

if ! [ -f "${BASH_UTILS_LOG}" ] 
then
	error "Unmet dependencies."
	echo "Abort."
	exit 1
fi

source "${BASH_UTILS_LOG}"

# default configuration
DAEMON_PID_FILE="/tmp/${APP_NAME}.pid"
DAEMON_SLEEP_TIME="10"

# trap interrupts for exiting safely
trap daemon_control SIGINT SIGQUIT SIGKILL
daemon_control() {
	echo -e "\nExiting safely ..."
	daemon_pid_reset
}

# can be used to cleanup when exiting daemon.
#daemon_cleanup() {
#	error "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
#	return 1
#}
#
# Giving the daemon a meaning.
#daemon_process() {
#	error "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
##	return 1
#}

daemon_pid_set() {
	local PID="$1"
	touch "${DAEMON_PID_FILE}" &> /dev/null
	if [ "$?" -ne 0 ]
	then
		error "Error creating pid-file at ${DAEMON_PID_FILE}."
		echo "Abort."
		exit 1
	fi
	echo "${PID}" > "${DAEMON_PID_FILE}" 
}

daemon_pid_get() {
	if [ -f "${DAEMON_PID_FILE}" ]
	then
		local PID=$(cat "${DAEMON_PID_FILE}")
		echo "${PID}"
	fi
}

daemon_pid_reset() {
	if [ -f "${DAEMON_PID_FILE}" ]
	then
		rm -f "${DAEMON_PID_FILE}"
	fi
}


# Calls daemon_process and sleeps afterwards.
#  The process can be savely killed due to traps.
daemon_start() {
	daemon_pid_set "${BASHPID}"
	while [ true ]
	do
		# Do the daemon-thing. 
		daemon_process

		if [ -z "${DAEMON_SLEEP_TIME}" ]
		then
			error "Illegal State: DAEMON_SLEEP_TIME empty!"
			echo "Abort."
			exit 1
		fi
		sleep "${DAEMON_SLEEP_TIME}"

		# Savely exiting our daemon.
		if [ -z $(daemon_pid_get) ]
		then
			daemon_cleanup
			echo "Goodbye ..."
			break
		fi
	done
}

daemon_stop() {
	daemon_pid_reset
}

daemon_service() {
	case "$1" in
	  start)
			info "Starting $APP_NAME"
			daemon_start &
			log "$APP_NAME is now running."
			;;
	  stop)
			info "Stopping $APP_NAME"
			daemon_stop
			;;
	  force-reload|restart)
			$0 stop
			$0 start
			;;
	  *)
			echo "Use: /etc/init.d/$APP_NAME {start|stop|restart|force-reload}"
			exit 1
		;;
	esac
}

#
# END OF FILE
#
