#
# Makefile -- 関数の単体テスト
#
TOP_DIR	        = ../..
BASH_BOOST_DIR  = $(TOP_DIR)

SRC_DIR         = $(TOP_DIR)/src
FUNCS_DIR       = $(SRC_DIR)/funcs
UTILS_DIR       = $(TOP_DIR)/utils

TEST_DIR        = ..
TEST_FUNCS_DIR  = .

DEBUG       = true
ENV         = env BASH_BOOST_DIR="$(BASH_BOOST_DIR)" DEBUG="${DEBUG}"
MKUT	    = $(ENV) $(UTILS_DIR)/mkut.bash
UT	    = $(ENV) $(UTILS_DIR)/ut.bash
TRIM_COLOR  = $(UTILS_DIR)/trim_color.bash

SRC_BASH_FILES = \
	exists.bash \
	array.bash \
	hash.bash \
	if.bash \
	log.bash \
	require.bash \
	date.bash \
	debug.bash \
	defun.bash \
	required.bash \
	file.bash \
	misc.bash \
	__.bash \
#        usage.bash \
#        class.bash \
#       aop.bash \
#

LOG_DIRS    = $(SRC_BASH_FILES:.bash=)
UT_FILES    = $(SRC_BASH_FILES:.bash=.ut)
LOG_FILES   = $(SRC_BASH_FILES:.bash=.log)

LIBBOOST    = ${FUNCS_DIR}/libboost

SHELL          = /bin/bash -o pipefail

vpath %.bash ${FUNCS_DIR}

.PRECIOUS : %.ut

all: $(LOG_FILES) 

%.ut: %.bash
	@echo \#\# Update $@
	$(MKUT) $* $@ > $@.new;
	rm -f $@;
	mv $@.new $@;

%.log : %.ut
	@echo \#\# Do unit test $*
	@$(UT) $< | tee /dev/tty | $(TRIM_COLOR) > $@;

clean:
	rm -rf ${LOG_FILES};
	rm -rf ${LOG_DIRS};

var_dump:
	@echo LOG_DIRS=$(LOG_DIRS)
	@echo SRC_BASH_FILES=$(SRC_BASH_FILES)
	@echo UT_FILES=$(UT_FILES)
	@echo LOG_FILES=$(LOG_FILES)
