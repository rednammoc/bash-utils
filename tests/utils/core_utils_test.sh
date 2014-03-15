#!/bin/bash
APP_NAME="list_utils_test.sh"
BASH_TEST_DIR=${BASH_SOURCE%/*}
BASH_UTILS_DIR="${BASH_TEST_DIR}/../../src/utils"
if [[ ! -d "$BASH_UTILS_DIR" ]]; then BASH_UTILS_DIR="$PWD"; fi
source "${BASH_UTILS_DIR}/core_utils.sh"

require "assert_utils.sh"

# Gather script-name and location
script="`readlink -e $0`"

# Disable setup and tear_down call.
ASSERT_UTILS_SETUP=1
ASSERT_UTILS_TEAR_DOWN=1

# Tests
function testCoreDepends_WhenCommandDoesNotExist_ReturnFalse
{
	assert_raises "depends \"not_existing_command\"" "1"
}

function testCoreDepends_WhenCommandDoesExist_ReturnTrue
{
	assert_raises "depends \"man\"" "0"
}

# Automatically run tests.
run_tests "${script}"
