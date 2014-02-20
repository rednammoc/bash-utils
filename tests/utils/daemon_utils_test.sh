#!/bin/bash
APP_NAME="daemon-utils-test"
CONFIG_FILE="config-utils-test.conf"

setup () {
	touch "${CONFIG_FILE}"
}

source ../../src/utils/daemon_utils.sh

# overwrite functions
config_validate () { return 0; }

setup

daemon_service $@
