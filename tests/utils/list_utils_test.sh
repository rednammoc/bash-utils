#!/bin/bash
APP_NAME="list_utils_test.sh"
TEST="`readlink -e $0`"
BASH_TEST_DIR=${BASH_SOURCE%/*}
BASH_UTILS_DIR="${BASH_TEST_DIR}/../../src/utils"
if [[ ! -d "$BASH_UTILS_DIR" ]]; then BASH_UTILS_DIR="$PWD"; fi
source "${BASH_UTILS_DIR}/core_utils.sh"

require "assert_utils.sh"
require "list_utils.sh"

list="/tmp/list_utils_test"

function setup
{
	touch "${list}"
}

function tear_down
{
	rm -rf "${list}"
}

function testListSize_WhenEmpty_ReturnZero
{
	assert "list_size \"${list}\"" "0"
}

function testListSize_WhenPutElementIntoEmptyList_ReturnOne
{
	list_put "${list}" "element"
	assert "list_size \"${list}\"" "1"
}

run_tests "${TEST}"
