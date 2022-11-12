#
# Makefile -- 関数の単体テスト
#
TOP_DIR	        = ../..
CURRENT_DIR     = .
FUNCS_DIR       = $(TOP_DIR)/funcs
EXTRA_FUNCS_DIR = $(FUNCS_DIR)/extra
TEST_DIR        = $(TOP_DIR)/test
TEST_FUNCS_DIR  = $(TEST_DIR)/funcs
TEST_EXTRA_DIR  = $(TEST_FUNCS_DIR)/extra

ENV	    = 
MKUT	    = $(ENV) $(TEST_FUNCS_DIR)/mkut.bash
UT	    = $(ENV) $(TEST_FUNCS_DIR)/ut.bash

SRC_BASH_FILES = \
	array.bash \
	date.bash \
	debug.bash \
	defun.bash \
	exists.bash \
	file.bash \
	if.bash \
	log.bash \
	required.bash \
	misc.bash \
	msg_catalog.bash \
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
	@${UT} $< | tee /dev/tty > $@;

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
