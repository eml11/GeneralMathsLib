! basic program to run through unit tests

program run_unit_tests

  use mod_rungekutta, mod_rungekutta_implicit
  implicit none

  call unittest_rungekutta()
  call unittest_rungekutta_implicit()

end program
