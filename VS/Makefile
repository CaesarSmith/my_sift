CC	= g++
CFLAGS	+= -Wall -Wextra -Wpedantic --std=c++11 -g3 -O3
BIN_DIR = ./bin
INC_DIR	= .
LIB_DIR	= ./lib
INCL	= -I"D:\Programs\opencv\build_mingw\include"
LIBS	= -L$(LIB_DIR) -lopensift "D:\Programs\opencv\build_mingw\x64\mingw\bin\libopencv_world460.dll"
# OBJ	= imgfeatures.o utils.o sift.o kdtree.o minpq.o xform.o
OBJ	= imgfeatures.o utils.o kdtree.o minpq.o xform.o
# BIN     = siftfeat match dspfeat match_num
BIN     = match

# all: $(BIN) libopensift.a
all: $(BIN)

# libopensift.a: $(OBJ)
	# ar rc $(LIB_DIR)/$@ $(OBJ)
	# ranlib  $(LIB_DIR)/$@

# siftfeat: libopensift.a siftfeat.cpp
	# $(CC) $(CFLAGS) $(INCL) siftfeat.c -o $(BIN_DIR)/$@ $(LIBS)

match: $(LIB_DIR)/libopensift.a match.cpp
	$(CC) $(CFLAGS) $(INCL) match.cpp -o $(BIN_DIR)/$@ $(LIBS)

match_num: libopensift.a match.c
	$(CC) $(CFLAGS) $(INCL) match_num.c -o $(BIN_DIR)/$@ $(LIBS)

# dspfeat: libopensift.a dspfeat.c
	# $(CC) $(CFLAGS) $(INCL) dspfeat.c -o $(BIN_DIR)/$@ $(LIBS)

imgfeatures.o: imgfeatures.cpp $(INC_DIR)/imgfeatures.h
	$(CC) $(CFLAGS) $(INCL) -c imgfeatures.cpp -o $@

utils.o: utils.cpp $(INC_DIR)/utils.h
	$(CC) $(CFLAGS) $(INCL) -c utils.cpp -o $@

# sift.o: sift.cpp $(INC_DIR)/sift.h
	# $(CC) $(CFLAGS) $(INCL) -c sift.cpp -o $@

kdtree.o: kdtree.cpp $(INC_DIR)/kdtree.h
	$(CC) $(CFLAGS) $(INCL) -c kdtree.cpp -o $@

minpq.o: minpq.cpp $(INC_DIR)/minpq.h
	$(CC) $(CFLAGS) $(INCL) -c minpq.cpp -o $@

xform.o: xform.cpp $(INC_DIR)/xform.h
	$(CC) $(CFLAGS) $(INCL) -c xform.cpp -o $@

clean:
	rm -f *~ *.o core

.PHONY: clean
