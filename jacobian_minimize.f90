module mod_jacobian_minimize

#define JACOBIAN_RES_TOL 1.0D-6

! not really the best way of doing this
#define JACOBIAN_DERIVATIVE_STEP = 1.0D-3

contains

subroutine jacobian_minimize(objective,x0,integer_args,double_args,func_arg)

  interface 
    function func_arg
    end function

    function objective(x0,integer_args,double_args,func_arg)
      interface
        function func_arg
        end function
      end interface
      double precision x0(:)
      integer integer_args(:)
      double precision double_args(:)
      double precision, dimension(size(x0)) :: objective
    end function

  end interface

  double precision x0(:)

  integer integer_args(:)
  double precision double_args(:)

  double precision, dimension(size(x0)) :: residual

  integer i
  double precision, dimension(size(x0),size(x0)) :: jacobian

  do

    residual = objective(x0,integer_args,double_args,func_arg)

    ! Want to compute this here not 
    ! to do one more step than required.
    if (residual < JACOBIAN_RES_TOL) then
      exit
    end if

    do i = 1, size(x0)

      ! should generalise
      x0(i) = x0(i) + JACOBIAN_DERIVATIVE_STEP
      jacobian(:,i) = objective(x0,integer_args,double_args,func_arg)
      x0(i) = x0(i) - JACOBIAN_DERIVATIVE_STEP


    end do
  end do

end subroutine

end module
