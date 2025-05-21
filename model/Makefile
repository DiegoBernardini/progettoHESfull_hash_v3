# compilatore da usare
CC  =  gcc

AR  =  ar
# flag di compilazione
CFLAGS  += -std=c99 -Wall -Werror -g -DDEBUG
ARFLAGS  =  rvs

# nome della cartella che contiene i file includes
INCDIR    = ./myInclude
#
INCLUDES 	= -I $(INCDIR)
LDFLAGS 	= -L.
OPTFLAGS	= -O3

# nome dell' eseguibile
EXE   = full_hash

# aggiungere qui altri targets
TARGETS		= full_hash

# phony target
.PHONY: all clean cleanall test
.SUFFIXES: .c .h

%: %.c
	$(CC) $(CFLAGS) $(INCLUDES) $(OPTFLAGS) -o $@ $< $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) $(OPTFLAGS) -c -o $@ $<


$(EXE): high_level_model.c
	$(CC) $(CFLAGS) $(INCLUDES) $^ -o $(EXE) $(LDFLAGS)

model: ./high_level_model.c
	$(CC) $(CFLAGS) -o $@ $^

all		: $(TARGETS)

clean 	:
	@-rm -f *.o

cleanall	: clean
	\rm -f *~ *.a *.dat *.txt model $(TARGETS) -r

# comando utilizzato per eseguire i test
test: full_hash
	./full_hash

# comando utilizzato per testare la gestione dei segnali
# test: farm
# 	./$(EXE) file* -d testdir -n 4 -q 2 -t 4000