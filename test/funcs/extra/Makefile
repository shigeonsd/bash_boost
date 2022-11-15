#
# Makefile -- extra 関数の単体テスト
#
TOP_DIR	        = ../../..
BASH_BOOST_DIR  = $(TOP_DIR)

FUNCS_DIR       = $(TOP_DIR)/funcs
UTILS_DIR       = $(TOP_DIR)/utils
EXTRA_FUNCS_DIR = $(FUNCS_DIR)/extra

TEST_DIR        = ../..
TEST_FUNCS_DIR  = ..
TEST_EXTRA_DIR  = .

DEBUG       = true
ENV         = env BASH_BOOST_DIR="$(BASH_BOOST_DIR)" DEBUG="${DEBUG}"
MKUT        = $(ENV) $(UTILS_DIR)/mkut.bash
UT          = $(ENV) $(UTILS_DIR)/ut.bash
TRIM_COLOR  = $(UTILS_DIR)/trim_color.bash

SRC_BASH_FILES =     \
	logfile.bash \
	usage.bash   \
	aop.bash     \
	load.bash    \
	class.bash   \
#

LOG_DIRS    = $(SRC_BASH_FILES:.bash=)
UT_FILES    = $(SRC_BASH_FILES:.bash=.ut)
LOG_FILES   = $(SRC_BASH_FILES:.bash=.log)

SHELL          = /bin/bash -o pipefail

vpath %.bash ${EXTRA_FUNCS_DIR}

.PRECIOUS : %.ut

all: $(LOG_FILES)

%.ut: %.bash
	@echo \#\# Update $@
	$(MKUT) extra/$* $@ > $@.new;
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
