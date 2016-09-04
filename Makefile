

MODULES = mod_rungekutta.mod mod_rungekutta_implicit.mod mod_jacobian_minimize.mod

all: run_unit_tests

run_unit_tests: run_unit_tests.f90 $(MODULES)
	gfortran run_unit_tests.f90

mod_rungekutta_implicit.mod: mod_jacobian_minimize.mod mod_rungekutta.mod rungekutta_implicit.f90
	gfortran -c rungekutta_implicit.f90

mod_jacobian_minimize.mod: jacobian_minimize.f90
	gfortran -c jacobian_minimize.f90

mod_rungekutta.mod: rungekutta.f90
	gfortran -c rungekutta.f90

clean:
	rm *.mod
