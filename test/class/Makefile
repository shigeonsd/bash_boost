#
# Makefile -- クラスの単体テスト
#
TOP_DIR	    = ../..
UTILS_DIR   = $(TOP_DIR)/utils
TEST_DIR    = $(TOP_DIR)/test
CLASS_DIR   = $(TOP_DIR)/class

MKUT	    = $(UTILS_DIR)/mkut.bash
UT	    = $(UTILS_DIR)/ut.bash

CLASS_FILES =    \
    Object.sh    \
    Date.sh      \
    DateTime.sh  \
    Array.sh     \
    Hash.sh      \

CLASSES     = $(CLASS_FILES:.sh=)
UT_FILES    = $(CLASS_FILES:.sh=.ut)
LOG_FILES   = $(CLASS_FILES:.sh=.log)

vpath %.sh ${CLASS_DIR}

.PRECIOUS : %.ut

all: $(LOG_FILES)

%.ut:%.sh
	@echo Update $@
	$(MKUT) $* $@ > $@.new;
	rm -f $@;
	mv $@.new $@;

%.log:%.ut
	@echo @@@ Do unit test $*
	${UT} $< > $@; cat $@;

clean:
	rm -rf ${LOG_FILES};
