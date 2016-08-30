subroutine rungekutta(func,y,x,order)
  !explicit
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

  enddo

end subroutine
