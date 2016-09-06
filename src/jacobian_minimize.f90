module mod_jacobian_minimize

#define JACOBIAN_RES_TOL 1.0D-10

! not really the best way of doing this
#define JACOBIAN_DERIVATIVE_STEP 1.0D-10

contains

subroutine jacobian_minimize(objective,x0,integer_args,double_args)

  interface 
    !function func_arg
    !end function

    function objective(x0,integer_args,double_args)
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

  integer, dimension(size(x0)) :: pivot
  integer info

  !print *, size(x0)

  do

    ! issue with relative residual
    residual = objective(x0,integer_args,double_args)

    print *, residual

    !exit

    ! Want to compute this here not 
    ! to do one more step than required.
    if (maxval(dabs(residual)) < JACOBIAN_RES_TOL) then
      exit
    end if

    !print *, maxval(dabs(residual))

    do i = 1, size(x0)

      ! should generalise
      x0(i) = x0(i) + JACOBIAN_DERIVATIVE_STEP
      jacobian(:,i) = objective(x0,integer_args,double_args)
      x0(i) = x0(i) - JACOBIAN_DERIVATIVE_STEP


    end do

    ! solve matrix equation with
    ! lapack routine - not really
    ! conserned with picking the
    ! best solver at the moment - probably
    ! worth picking based on size of input
    call SGESV(size(residual),1,jacobian,size(residual),pivot,residual,size(residual),info)

    print *, residual

    exit

    ! update x0
    x0 = x0 - residual

  end do

end subroutine

function objective_unittests(x0,integer_args,double_args)

  integer integer_args(:) 
  double precision double_args(:)
  double precision x0(:)

  double precision, dimension(size(x0)) :: objective_unittests

  !really trivial residual
  objective_unittests = double_args - x0

end function


subroutine unittest_jacobian_minimize()

  integer, dimension(1) :: integer_args
  double precision, dimension(2) :: double_args 

  double precision, dimension(2) :: x0

  double precision, dimension(2) :: er

  integer_args(1) = 1

  double_args(1) = 0.1
  double_args(2) = 10.0

  x0(1) = 1.0
  x0(2) = 1.0

  !print *, size(x0)

  call jacobian_minimize(objective_unittests,x0,integer_args,double_args)

  er = (double_args - x0)/DABS(double_args)

  print *, x0
  print *, er

end subroutine



end module
