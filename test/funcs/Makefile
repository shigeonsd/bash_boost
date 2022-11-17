#
# Makefile -- 関数の単体テスト
#
TOP_DIR	        = ../..
BASH_BOOST_DIR  = $(TOP_DIR)

SRC_DIR         = $(TOP_DIR)/funcs
FUNCS_DIR       = $(SRC_DIR)/funcs
UTILS_DIR       = $(TOP_DIR)/utils
EXTRA_FUNCS_DIR = $(FUNCS_DIR)/extra

TEST_DIR        = ..
TEST_FUNCS_DIR  = .
TEST_EXTRA_DIR  = $(TEST_FUNCS_DIR)/extra

DEBUG       = true
ENV         = env BASH_BOOST_DIR="$(BASH_BOOST_DIR)" DEBUG="${DEBUG}"
MKUT	    = $(ENV) $(UTILS_DIR)/mkut.bash
UT	    = $(ENV) $(UTILS_DIR)/ut.bash
TRIM_COLOR  = $(UTILS_DIR)/trim_color.bash

SRC_BASH_FILES = \
	array.bash \
	date.bash \
	debug.bash \
	log.bash \
	defun.bash \
	required.bash \
	exists.bash \
	file.bash \
	if.bash \
	misc.bash \
	__.bash \
	require.bash \
#

LOG_DIRS    = $(SRC_BASH_FILES:.bash=)
UT_FILES    = $(SRC_BASH_FILES:.bash=.ut)
LOG_FILES   = $(SRC_BASH_FILES:.bash=.log)
EXTRA_DIR   = extra

SHELL          = /bin/bash -o pipefail

vpath %.bash ${FUNCS_DIR}

.PRECIOUS : %.ut

all: $(LOG_FILES) extra-all

%.ut: %.bash
	@echo \#\# Update $@
	$(MKUT) $* $@ > $@.new;
	rm -f $@;
	mv $@.new $@;

%.log : %.ut
	@echo \#\# Do unit test $*
	@$(UT) $< | tee /dev/tty | $(TRIM_COLOR) > $@;

extra-all:
	(cd ${EXTRA_DIR}; make all)

clean: extra-clean
	rm -rf ${LOG_FILES};
	rm -rf ${LOG_DIRS};

extra-clean:
	(cd ${EXTRA_DIR}; make clean)

var_dump:
	@echo LOG_DIRS=$(LOG_DIRS)
	@echo SRC_BASH_FILES=$(SRC_BASH_FILES)
	@echo UT_FILES=$(UT_FILES)
	@echo LOG_FILES=$(LOG_FILES)
