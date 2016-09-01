module mod_rungekutta

contains

subroutine rungekutta(func,y,x,order)
  !explicit
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
  
  double precision, dimension(size(y)) :: retar
  double precision, dimension(size(y)) :: k
  double precision deltax
  
  !allocate(retar(size(y)))
  !allocate(k(size(y)))
  
  deltax = (x(2) - x(1))/1000.0
  
  retar = y
  
  do 
    k = func(y,x(1))
    retar = k*deltax
  
    k = func(y + 0.5D0*k*deltax, x(1) + 0.5D0*deltax)
    retar = retar + 2D0*k*deltax
  
    k = func(y + 0.5D0*k*deltax, x(1) + 0.5D0*deltax)
    retar = retar + 2D0*k*deltax

    k = func(y + k*deltax, x(1) + deltax)
    retar = retar + k*deltax
    retar = retar/6.0D0
    x(1) = x(1) + deltax
    y = y + retar

    ! may need to go at top
    if (x(1) .ge. x(2)) then
      exit
    end if

  end do

  !deallocate(retar)
  !deallocate(k)

end subroutine

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
