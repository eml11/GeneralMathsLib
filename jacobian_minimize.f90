module mod_jacobian_minimize

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

end subroutine

end module
