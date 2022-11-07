#
# Makefile -- 関数の単体テスト
#
TOP_DIR	    = ../..
CURRENT_DIR = .
TEST_DIR    = $(TOP_DIR)/test
FUNCS_DIR   = $(TOP_DIR)/funcs

ENV	    = 
MKUT	    = $(ENV) $(CURRENT_DIR)/mkut.bash
UT	    = $(ENV) $(CURRENT_DIR)/ut.bash

FUNCS_FILES = \
	array.bash \
	date.bash \
	debug.bash \
	exists.bash \
	file.bash \
	if.bash \
	log.bash \
	misc.bash \
	required.bash \
#

FUNCS       = $(FUNCS_FILES:.bash=)
UT_FILES    = $(FUNCS_FILES:.bash=.ut)
LOG_FILES   = $(FUNCS_FILES:.bash=.log)

SHELL          = /bin/bash -o pipefail

vpath %.bash ${FUNCS_DIR}

.PRECIOUS : %.ut

all: $(LOG_FILES)

%.ut: %.bash
	@echo Update $@
	$(MKUT) $* $@ > $@.new;
	rm -f $@;
	mv $@.new $@;

%.log : %.ut
	@echo @@@ Do unit test $*
	@${UT} $< | tee /dev/tty > $@;

clean:
	rm -rf ${LOG_FILES};
	rm -rf ${FUNCS};

var_dump:
	@echo $(FUNCS)
	@echo $(FUNCS_FILES)
	@echo $(UT_FILES)
	@echo $(LOG_FILES)
