#
# Makefile -- モジュールの単体テスト
#
TOP_DIR	    = ../..
CURRENT_DIR = .
UTILS_DIR   = $(TOP_DIR)/utils
TEST_DIR    = $(TOP_DIR)/test
MODULES_DIR   = $(TOP_DIR)/modules

MKUT	    = env BASHMODULEPATH=$(BASHMODULEPATH) $(CURRENT_DIR)/mkut.bash
UT	    = env BASHMODULEPATH=$(BASHMODULEPATH) $(CURRENT_DIR)/ut.bash

MODULES_FILES = \
    template_method.sh      \
#

MODULES     = $(MODULES_FILES:.sh=)
UT_FILES    = $(MODULES_FILES:.sh=.ut)
LOG_FILES   = $(MODULES_FILES:.sh=.log)

SHELL         = /bin/bash -o pipefail
BASHMODULEPATH = $(MODULES_DIR)

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

var_dump:
	@echo $(MODULES)
	@echo $(MODULES_FILES)
	@echo $(UT_FILES)
	@echo $(LOG_FILES)
	@echo $(BASHMODULEPATH)
