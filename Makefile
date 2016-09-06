
BASEDIR = $(PWD)

SRC = $(BASEDIR)/src
LIB = $(BASEDIR)/lib
OBJ = $(BASEDIR)/obj
BIN = $(BASEDIR)/bin
INCLUDE = $(BASEDIR)/include


FILELIST = $(wildcard $(SRC)/*.f90)

BINARYSOURCES = run_unit_tests.f90

# remove binary files
# will probably do this 
# in a more sensible mannor
# at some point
FILELISTOBJ = $(filter-out $(SRC)/run_unit_tests.f90, $(FILELIST))

BASES = $(notdir $(basename $(FILELISTOBJ)))

MODULES = $(addsuffix .mod, $(addprefix $(INCLUDE)/, $(addprefix mod_, $(BASES))))
OBJECTS = $(addprefix $(OBJ)/, $(addsuffix .o, $(BASES)))


FFLAGS = -cpp

FLIBS = -lblas -llapack

UNIT_TEST = run_unit_tests


all: directories $(BIN)/$(UNIT_TEST)

# need to be rewritten
$(BIN)/$(UNIT_TEST): $(SRC)/run_unit_tests.f90 $(MODULES) $(OBJECTS)
	cd $(SRC) && gfortran $(FFLAGS) -o $(UNIT_TEST) -I$(INCLUDE) run_unit_tests.f90 $(OBJECTS) $(FLIBS)
	mv $(SRC)/$(UNIT_TEST) $(BIN)/$(UNIT_TEST)

$(INCLUDE)/mod_rungekutta_implicit.mod: $(INCLUDE)/mod_jacobian_minimize.mod $(INCLUDE)/mod_rungekutta.mod $(INCLUDE)/mod_timestepping.mod $(SRC)/rungekutta_implicit.f90
	cd $(SRC) && gfortran $(FFLAGS) -I$(INCLUDE) -c rungekutta_implicit.f90
	mv $(SRC)/mod_rungekutta_implicit.mod $(INCLUDE)/mod_rungekutta_implicit.mod
	mv $(SRC)/rungekutta_implicit.o $(OBJ)/rungekutta_implicit.o

$(INCLUDE)/mod_jacobian_minimize.mod: $(SRC)/jacobian_minimize.f90 
	cd $(SRC) && gfortran $(FFLAGS) -I$(INCLUDE) -c jacobian_minimize.f90
	mv $(SRC)/mod_jacobian_minimize.mod $(INCLUDE)/mod_jacobian_minimize.mod
	mv $(SRC)/jacobian_minimize.o $(OBJ)/jacobian_minimize.o

$(INCLUDE)/mod_rungekutta.mod: $(SRC)/rungekutta.f90 $(INCLUDE)/mod_timestepping.mod
	cd $(SRC) && gfortran $(FFLAGS) -I$(INCLUDE) -c rungekutta.f90
	mv $(SRC)/mod_rungekutta.mod $(INCLUDE)/mod_rungekutta.mod
	mv $(SRC)/rungekutta.o $(OBJ)/rungekutta.o

$(INCLUDE)/mod_timestepping.mod: $(SRC)/timestepping.f90
	cd $(SRC) && gfortran $(FFLAGS) -I$(INCLUDE) -c timestepping.f90
	mv $(SRC)/mod_timestepping.mod $(INCLUDE)/mod_timestepping.mod
	mv $(SRC)/timestepping.o $(OBJ)/timestepping.o

directories:
	mkdir -p $(LIB)
	mkdir -p $(OBJ)
	mkdir -p $(BIN)
	mkdir -p $(INCLUDE)

print-%  : ; $(info $* is $(flavor $*) variable set to [$($*)]) @true

clean:
	cd $(OBJ) && rm -f *.o
	cd $(BIN) && rm -f *
	cd $(INCLUDE) && rm -f *.mod
	cd $(LIB) && rm -f *

cleanall:
	rm -r $(OBJ)
	rm -r $(BIN)
	rm -r $(INCLUDE)
	rm -r $(LIB)
	cd $(SRC) && rm *.swp 
	rm *.swp
	
