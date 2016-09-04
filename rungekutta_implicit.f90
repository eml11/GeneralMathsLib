module mod_rungekutta_implicit

use mod_rungekutta 
use mod_jacobian_minimize

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
  
  double precision, dimension(size(y)) :: ynext

  double precision deltax

  integer integer_args(1)
  double precision double_args(2 + size(y))

  deltax = (x(2) - x(1))/1000.0

  do
    
    ynext = y

    integer_args(1) = order
    double_args(1) = x1
    double_args(2) = deltax
    double_args(2:) = y

    call jacobian_minimize(objective_rkimp,ynext,integer_args,double_args,func)

    y = ynext

    x(1) = x(1) + deltax

    ! may need to go at top
    if (x(1) .ge. x(2)) then
      exit
    end if

  end do

end subroutine

function objective_rkimp(ynext,integer_args,double_args,func_arg)

  interface
    function func_arg(y,x)
      double precision, dimension(:) :: y
      double precision x
      double precision, dimension(size(y)) :: func
    end function
  end interface

  integer integer_args(:)
  double precision double_args(:)

  double precision ynext(:)

  double precision, dimension(size(ynext)) :: objective_rkimp

  double precision, dimension(size(ynext)) :: y
  double precision x1
  double precision deltax
  integer order

  order = integer_args(1)
  x1 = double_args(1)
  deltax = double_args(2)

  y = double_args(2:)

  ! how do I pass in func?
  objective_rkimp = ynext - y - rkstep(func_arg,ynext,x1,deltax,order)

end function


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
