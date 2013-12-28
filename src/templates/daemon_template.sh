#!/bin/bash
# name: daemon_template.sh
# description: This template can be used to develop a daemon-process.
# version: 0.1
# author: rednammoc
#

APP_NAME="daemon_template"
APP_DESCRIPTION="description of what this daemon does."

source "deamon_utils.sh"

# 
daemon_cleanup() {
	echo "Nothing to do right now."
	return 1
}

# .
daemon_load_data() {
	echo "Nothing to do right now."
	return 1
}

# .
daemon_process_data() {
	echo "Nothing to do right now."
	return 1
}

#
# END OF FILE
#
