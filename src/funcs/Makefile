#
# Makefile -- 関数の単体テスト
#
TOP_DIR	        = ../..
BASH_BOOST_DIR  = $(TOP_DIR)

SRC_DIR         = $(TOP_DIR)/src
FUNCS_DIR       = $(SRC_DIR)/funcs
LIB_DIR         = $(TOP_DIR)/lib
UTILS_DIR       = $(TOP_DIR)/utils

SRC_FILES  = \
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
	usage.bash \
#	class.bash \
#	aop.bash \
#
LIB_FILE_IN = libbashboost.in
LIB_FILE    = $(LIB_FILE_IN:.in=.bash)
TARGET      = ${LIB_DIR}/$(LIB_FILE)

SHELL          = /bin/bash -o pipefail

vpath %.bash ${FUNCS_DIR}

all: $(TARGET)

$(TARGET) : ${LIB_DIR} ${LIB_FILE_IN} ${SRC_FILES}
	cat ${LIB_FILE_IN} > $@
	cat ${SRC_FILES} | grep -v '^#!'>> $@ 

${LIB_DIR}:
	mkdir $@;

clean: 
	rm -rf ${TARGET};

var_dump:
	@echo TARGET=$(TARGET)
	@echo SRC_FILES=$(SRC_FILES)
