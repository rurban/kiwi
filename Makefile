DIALECT = mw
# DIALECT = pw
# DIALECT = creole
SYNTAX = $(DIALECT)-syntax
TARGETS = $(SYNTAX)
ALLTARGETS = bin/mw-parser bin/pw-parser bin/creole-parser bin/$(DIALECT)-memtest bin/testlist
OS=$(shell uname)

CFLAGS = -O3 -g3 -Wall -std=gnu99 -DDIALECT=$(DIALECT)
ifneq ($(OS), CYGWIN_NT-6.1)
CFLAGS += -fPIC 
endif

S   = bstrlib list content io parse stack
SRC = $(S:%=src/%.c)
OBJ = $(SRC:src/%.c=src/%.o)

main : $(TARGETS) libkiwi.so

all : $(ALLTARGETS) libkiwi.so

mw-syntax : bin/mw-parser src/mw-syntax.leg.o

pw-syntax : bin/pw-parser src/pw-syntax.leg.o

creole-syntax : bin/creole-parser src/creole-syntax.leg.o

bin/mw-parser : $(OBJ) src/mw-syntax.leg.o src/main.o
	mkdir -p bin
	$(CC) $(CFLAGS) -o $@ src/main.o src/mw-syntax.leg.o $(OBJ) 

bin/pw-parser : $(OBJ) src/pw-syntax.leg.o src/main.o
	mkdir -p bin
	$(CC) $(CFLAGS) -o $@ src/main.o src/pw-syntax.leg.o $(OBJ) 

bin/creole-parser : $(OBJ) src/creole-syntax.leg.o src/main.o
	mkdir -p bin
	$(CC) $(CFLAGS) -o $@ src/main.o src/creole-syntax.leg.o $(OBJ) 

src/%-syntax.leg.c : src/%-syntax.leg
	leg -o $@ $<

#src/%-syntax.leg.o : src/%-syntax.leg.c
#	$(CC) $(CFLAGS) -o $@ $<

libkiwi.so : $(OBJ)
ifeq ($(OS), Darwin)
	$(CC) $(CFLAGS) -dynamiclib -shared -o libkiwi.so $(OBJ) src/$(DIALECT)-syntax.leg.o
else
	$(CC) $(CFLAGS) -shared -o libkiwi.so $(OBJ) src/$(DIALECT)-syntax.leg.o
endif

testlist: bin/testlist 

bin/testlist : src/testlist.o src/bstrlib.o src/list.o
	$(CC) $(CFLAGS) -o $@ src/testlist.o src/bstrlib.o src/list.o

memtest: bin/$(DIALECT)-memtest

bin/$(DIALECT)-memtest : src/memtest.o $(OBJ) src/$(DIALECT)-syntax.leg.o
	$(CC) $(CFLAGS) -o $@ src/memtest.o $(OBJ) src/$(DIALECT)-syntax.leg.o

spectest: $(SYNTAX) spec/test_spec.rb
	cd spec; ruby test_spec.rb; cd ..

mw_tests: mw-syntax spec/mw/parserTests.txt
	ruby spec/mw/mw_tests.rb

clean : .FORCE
	rm -rf bin/* *~ *.o *.[pl]eg.[cd] *.so *.a $(ALLTARGETS)

.FORCE :
