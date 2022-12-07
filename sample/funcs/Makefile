#
# Makefile -- libbashboost ライブラリ作成
#
TOP_DIR	        = ../..
BASH_BOOST_DIR  = $(TOP_DIR)

CURRENT_DIR     = .
SRC_DIR         = $(TOP_DIR)/src
FUNCS_DIR       = $(SRC_DIR)/funcs
LIB_DIR         = $(TOP_DIR)/lib
UTILS_DIR       = $(TOP_DIR)/utils

DEBUG		= env DEBUG=0

USAGE_SAMPLE	 = ${CURRENT_DIR}/usage_sample.bash
LAMBDA_SAMPLE	 = ${CURRENT_DIR}/lambda_sample.bash
TRY_CATCH_SAMPLE = ${CURRENT_DIR}/try_catch_sample.bash
AOP_SAMPLE	 = ${CURRENT_DIR}/aop_sample.bash

# for Usage
usage:
	${DEBUG} ${USAGE_SAMPLE}
	@echo
	${DEBUG} ${USAGE_SAMPLE} -h
	@echo
	${DEBUG} ${USAGE_SAMPLE} -x -y=128 -z file1 file2
	@echo
	${DEBUG} ${USAGE_SAMPLE} --exclude --yield=256 --quiet file1 file2
	@echo
	${DEBUG} ${USAGE_SAMPLE} file1 file2 

# for Lambda
lambda:
	${DEBUG} ${LAMBDA_SAMPLE}

# for try/catch/throw/finally
try_catch:
	${DEBUG} ${TRY_CATCH_SAMPLE}

# for AOP
#
aop_noadvisor:
	${DEBUG} ${AOP_SAMPLE}

aop_laptime:
	${DEBUG} ${AOP_SAMPLE} laptime_advisor

aop_debug:
	${DEBUG} ${AOP_SAMPLE} debug_advisor

aop_laptime_debug:
	${DEBUG} ${AOP_SAMPLE} laptime_advisor debug_advisor
