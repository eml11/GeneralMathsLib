module mod_timestepping

implicit none

#define MAX_TIMESTEP 1.0e6
#define MIN_TIMESTEP 1.0e-10
#define ADAPTIVE_MAXIMUM_CHANGE 1.0e-4

contains

function adaptive_timestep(this,prev,step)

  double precision this(:)
  double precision prev(:)

  double precision step

  double precision adaptive_timestep

  adaptive_timestep = minval(dabs(ADAPTIVE_MAXIMUM_CHANGE*step*prev/(this - prev)))

  adaptive_timestep = max(adaptive_timestep,MIN_TIMESTEP)
  adaptive_timestep = min(adaptive_timestep,MAX_TIMESTEP)

end function

end module
