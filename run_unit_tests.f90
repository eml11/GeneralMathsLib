! basic program to run through unit tests

program run_unit_tests

  use mod_rungekutta
  use mod_jacobian_minimize
  use mod_rungekutta_implicit
  implicit none

  print *, "Testing: rungekutta"
  call unittest_rungekutta()

  print *, ""
  print *, "Testing: jacobian_minimize"
  call unittest_jacobian_minimize()

  print *, ""
  print *, "Testing: rungekutta_implicit"
  !call unittest_rungekutta_implicit()

end program
