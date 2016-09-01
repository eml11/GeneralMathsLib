module mod_rungekutta_implicit

use mod_rungekutta

implicit none

contains


subroutine rungekutta_implicit(func,y,x,order)
  ! implicit
  ! anyway to compatmentalise
  ! some of this so that there is
  ! less duplicated code with the 
  ! explicit scheme

  interface
    function func(y,x)
      double precision, dimension(:) :: y
      double precision x
      double precision, dimension(size(y)) :: func
    end function
  end interface

  double precision, dimension(:) :: y
  double precision, dimension(2) :: x
  integer order !not sure if there is an efficient formula for this
  
  double precision deltax

  deltax = (x(2) - x(1))/1000.0

  retar = y

  do

    call rkstep(func,y,x(1),deltax,order)

    x(1) = x(1) + deltax

    ! may need to go at top
    if (x(1) .ge. x(2)) then
      exit
    end if

  end do

end subroutine


subroutine unittest_rungekutta_implicit()

  double precision, dimension(1) :: y
  double precision, dimension(2) :: x
  double precision exact
  double precision er

  x(1) = 0.0
  x(2) = 10.0

  y(1) = 1.0

  call rungekutta_implicit(simple_decay,y,x,4)

  exact = DEXP(-x(2))
  er = (exact - y(1))/DABS(exact)

  ! eventually print these to a file when unit
  ! testing
  print *, er

end subroutine


end module 
