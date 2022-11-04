#
# Makefile -- クラスの単体テスト
#
TOP_DIR	    = ../..
UTILS_DIR   = $(TOP_DIR)/utils
TEST_DIR    = $(TOP_DIR)/test
CLASS_DIR   = $(TOP_DIR)/class

MKUT	    = env BASHCLASSPATH=$(BASHCLASSPATH) $(UTILS_DIR)/mkut.bash
UT	    = env BASHCLASSPATH=$(BASHCLASSPATH) $(UTILS_DIR)/ut.bash

CLASS_CORE_FILES = \
    Object.sh      \
    Date.sh        \
    DateTime.sh    \
    Array.sh       \
    Hash.sh        \
#

CLASS_TEST_FILES =    \
    PropertyTest.sh   \
#

CLASS_FILES =    \
    $(CLASS_CORE_FILES) \
    $(CLASS_TEST_FILES) \
#

CLASSES     = $(CLASS_FILES:.sh=)
UT_FILES    = $(CLASS_FILES:.sh=.ut)
LOG_FILES   = $(CLASS_FILES:.sh=.log)

SHELL         = /bin/bash -o pipefail
BASHCLASSPATH = $(CLASS_DIR):$(CLASS_DIR)/ut

vpath %.sh ${BASHCLASSPATH}

.PRECIOUS : %.ut

all: $(LOG_FILES)

%.ut: %.sh
	@echo Update $@
	$(MKUT) $* $@ > $@.new;
	rm -f $@;
	mv $@.new $@;

#%.log : %.ut
%.log : %.ut
	@echo @@@ Do unit test $*
	@${UT} $< | tee /dev/tty > $@;

clean:
	rm -rf ${LOG_FILES};

%.logx : 
	@echo @@@ Do unit test $*
    

var_dump:
	@echo $(CLASSES)
	@echo $(CLASS_FILES)
	@echo $(UT_FILES)
	@echo $(LOG_FILES)
	@echo $(BASHCLASSPATH)
