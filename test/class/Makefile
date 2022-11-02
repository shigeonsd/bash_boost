#
# Makefile -- クラスの単体テスト
#
TOP_DIR	   = ../..
UTIL_DIR   = $(TOP_DIR)/util
TEST_DIR   = $(TOP_DIR)/test
CLASS_DIR  = $(TOP_DIR)/class

MKUT	   = $(UTIL_DIR)/mkut.bash
UT	   = $(UTIL_DIR)/ut.bash

CLASS_FILES =    \
    Object.sh    \
    Date.sh      \
    DateTime.sh  \
    Array.sh     \
    Hash.sh      \

UT_FILES = $(CLASS_FILES:.sh=.ut)

all:
	@echo $(UT_FILES);
	
