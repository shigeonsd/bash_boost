#
# Makefile -- libbashboost ライブラリ作成
#
TOP_DIR	        = ../..
BASH_BOOST_DIR  = $(TOP_DIR)

CURRENT_DIR     = .
SRC_DIR         = $(TOP_DIR)/src
FUNCS_DIR       = $(SRC_DIR)/funcs
LIB_DIR         = $(TOP_DIR)/lib
UTILS_DIR       = $(TOP_DIR)/utils

SRC_FILES  = \
	is.bash \
	if.bash \
	debug.bash \
	exists.bash \
	array.bash \
	hash.bash \
	log.bash \
	require.bash \
	date.bash \
	defun.bash \
	required.bash \
	file.bash \
	misc.bash \
	__.bash \
	usage.bash \
	class.bash \
	aop.bash \
	string.bash \
#
SRC2_FILES  = \
	preprocessor.bash \
#
LIB_FILE_IN = libbashboost.in
LIB_FILE    = $(LIB_FILE_IN:.in=.bash)
TARGET      = ${LIB_DIR}/$(LIB_FILE)

SHELL       = /bin/bash -o pipefail

vpath %.bash ${FUNCS_DIR}

all: $(TARGET)

$(TARGET) : ${LIB_DIR} ${LIB_FILE_IN} ${SRC_FILES} ${SRC2_FILES}
	cat ${LIB_FILE_IN} > $@
	cat ${SRC_FILES} | grep -v '^#!' >> $@ 
	for f in ${SRC2_FILES}; do \
             echo "require $$f"; \
        done >> $@ 

	

${LIB_DIR}:
	mkdir $@;

clean: 
	rm -rf ${TARGET};

var_dump:
	@echo TARGET=$(TARGET)
	@echo SRC_FILES=$(SRC_FILES)
