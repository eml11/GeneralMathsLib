
# possibly modify to do automatically on single
# list
MODULES = mod_rungekutta.mod mod_rungekutta_implicit.mod mod_jacobian_minimize.mod
OBJECTS = jacobian_minimize.o rungekutta.o rungekutta_implicit.o

FFLAGS = -cpp

FLIBS = -lblas -llapack

UNIT_TEST = run_unit_tests

all: run_unit_tests

$(UNIT_TEST): run_unit_tests.f90 $(MODULES) $(OBJECTS)
	gfortran $(FFLAGS) -o $(UNIT_TEST) run_unit_tests.f90 $(OBJECTS) $(FLIBS)

mod_rungekutta_implicit.mod: mod_jacobian_minimize.mod mod_rungekutta.mod rungekutta_implicit.f90
	gfortran $(FFLAGS) -c rungekutta_implicit.f90

mod_jacobian_minimize.mod: jacobian_minimize.f90
	gfortran $(FFLAGS) -c jacobian_minimize.f90

mod_rungekutta.mod: rungekutta.f90
	gfortran $(FFLAGS) -c rungekutta.f90

clean:
	rm *.mod

cleanall: clean
	rm *.swp
