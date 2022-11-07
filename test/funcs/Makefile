#
# Makefile -- 関数の単体テスト
#
TOP_DIR	    = ../..
CURRENT_DIR = .
TEST_DIR    = $(TOP_DIR)/test
FUNCS_DIR   = $(TOP_DIR)/funcs

ENV	    = env BASHMODULEPATH=$(BASHMODULEPATH)
MKUT	    = $(ENV) $(CURRENT_DIR)/mkut.bash
UT	    = $(ENV) $(CURRENT_DIR)/ut.bash

FUNCS_FILES = \
    core.sh      \
    defun.sh      \
#

FUNCS       = $(FUNCS_FILES:.sh=)
UT_FILES    = $(FUNCS_FILES:.sh=.ut)
LOG_FILES   = $(FUNCS_FILES:.sh=.log)

SHELL          = /bin/bash -o pipefail
BASHMODULEPATH = $(FUNCS_DIR)

vpath %.sh ${BASHMODULEPATH}

.PRECIOUS : %.ut

all: $(LOG_FILES)

%.ut: %.sh
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
	@echo $(BASHMODULEPATH)
