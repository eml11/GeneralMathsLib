subroutine rungekutta_implicit(func,y,x,order)
  ! implicit
  ! anyway to compatmentalise
  ! some of this so that there is
  ! less duplicated code with the 
  ! explicit scheme
  interface
    function func(y,x)
      double precision, allocatable y
      double precision x
    end function
  end interface

  double precision, allocatable y
  double precision, size(2) x
  integer order !not sure if there is an efficient formula for this
  
  double precision, allocatable retar
  double precision, allocatable k
  double precision deltax
  
  deltax = (x(2) - x(1))/100.0
  
  do 
    k = func(y,x(1))
    retar = retar + k
  
    k = func(y + k, x(1) + 0.5D0*deltax)
    retar = retar + 2D0*k
  
    k = func(y + k, x(1) + 0.5D0*deltax)
    retar = retar + 2D0*k

    k = func(y + k, x(1) + deltax)
    retar = retar + k
    retar = retar/6.0D0
    x(1) = x(1) + deltax

    if x(1).ge.x(2)
      break
    end if

  end do

end subroutine

function simple_decay(y,x)
  double precision, allocatable y
  double precision x

  return -x
end function

subroutine unittest_rungekutta()

  double precision, allocatable y
  double precision, size(2) x
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
  print(*,*) er

end subroutine
