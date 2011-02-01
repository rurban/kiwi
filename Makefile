DIALECT = mw-
# DIALECT = mw-
# DIALECT = creole-
SYNTAX = $(DIALECT)syntax
EXAMPLES = syntax
OS=$(shell uname)

CFLAGS = -O3 -g3 -Wall -std=gnu99 -DDIALECT=$(DIALECT)
ifneq ($(OS), CYGWIN_NT-6.1)
CFLAGS += -fPIC 
endif

S   = $(SYNTAX).leg bstrlib list content io parse stack
SRC = $(S:%=src/%.c)
OBJ = $(SRC:src/%.c=src/%.o)

all : $(EXAMPLES) libkiwi.so

syntax : bin/$(PREFIX)parser

bin/$(PREFIX)parser : $(OBJ) src/main.o
	mkdir -p bin
	$(CC) $(CFLAGS) -o bin/$(PREFIX)parser src/main.o $(OBJ) 

src/$(SYNTAX).leg.c : src/$(SYNTAX).leg
	leg -o src/$(SYNTAX).leg.c src/$(SYNTAX).leg

libkiwi.so : $(OBJ)
ifeq ($(OS), Darwin)
	$(CC) $(CFLAGS) -dynamiclib -shared -o libkiwi.so $(OBJ)
else
	$(CC) $(CFLAGS) -shared -o libkiwi.so $(OBJ)
endif

testlist: bin/testlist 

bin/testlist : src/testlist.o src/bstrlib.o src/list.o
	$(CC) $(CFLAGS) -o bin/testlist src/testlist.o src/bstrlib.o src/list.o

memtest: bin/$(DIALECT)memtest

bin/$(DIALECT)memtest : $(OBJ) src/memtest.o
	$(CC) $(CFLAGS) -o bin/$(DIALECT)memtest src/memtest.o $(OBJ)


clean : .FORCE
	rm -rf bin/* *~ *.o *.[pl]eg.[cd] *.so *.a $(EXAMPLES)

.FORCE :
