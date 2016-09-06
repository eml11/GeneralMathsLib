module mod_rungekutta

use mod_timestepping

implicit none

contains

subroutine rungekutta(func,y,x,order)
  !explicit
  interface
    function func(yf,xf)
      implicit none
      double precision, dimension(:) :: yf
      double precision xf
      double precision, dimension(size(yf)) :: func
    end function
  end interface

  double precision y(:)
  double precision, dimension(2) :: x
  integer order !not sure if there is an efficient formula for this
  
  double precision, dimension(size(y)) :: ynext

  double precision deltax

  !procedure (func), pointer :: func_ptr => null()

  !func_ptr => func

  deltax = (x(2) - x(1))/1000.0
  
  do 
   
    ynext = y + rkstep(func,y,x(1),deltax,order)  

    deltax = adaptive_timestep(ynext,y,deltax)

    x(1) = x(1) + deltax
    y = ynext

    ! may need to go at top
    if (x(1) .ge. x(2)) then
      exit
    end if

  end do

end subroutine

 ! may want to precompute array for the
 ! order rather than passing it in
function rkstep(func,y,x,deltax,order)

  interface
    function func(yf,xf)
      implicit none
      double precision, dimension(:) :: yf
      double precision xf
      double precision, dimension(size(yf)) :: func
    end function
  end interface


  !procedure (func), pointer :: func_ptr

  double precision, dimension(:) :: y
  double precision x
  double precision deltax
  integer order 

  double precision, dimension(size(y)) :: rkstep
  double precision, dimension(size(y)) :: k

  k = func(y,x)
  rkstep = k*deltax

  k = func(y + 0.5D0*k*deltax, x + 0.5D0*deltax)
  rkstep = rkstep + 2D0*k*deltax

  k = func(y + 0.5D0*k*deltax, x + 0.5D0*deltax)
  rkstep = rkstep + 2D0*k*deltax

  k = func(y + k*deltax, x + deltax)
  rkstep = rkstep + k*deltax
  rkstep = rkstep/6.0D0

end function

function simple_decay(y,x)
  double precision, dimension(:) :: y
  double precision x
  double precision, dimension(size(y)) :: simple_decay

  simple_decay(1) = -1.0D0*y(1)
end function

subroutine unittest_rungekutta()

  double precision, dimension(1) :: y
  double precision, dimension(2) :: x
  double precision exact
  double precision er

  x(1) = 0.0
  x(2) = 10.0

  y(1) = 1.0

  call rungekutta(simple_decay,y,x,4)

  exact = DEXP(-x(2))
  er = (exact - y(1))/DABS(exact)
  
  ! eventually print these to a file when unit
  ! testing
  print *, er

end subroutine

end module
