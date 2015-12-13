function dx1 = err_simulate(dx0, u0, xnom0, xnom1, simulate_f, sim_time, model, idx, model_bias, magic_factor, x1star)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

  % dx0 is a state relative to some nominal trajectory
  x0 = compose_dx(xnom0, dx0);
  
  % x1 = run simulator on x0, u0
  x1 = feval(simulate_f, x0, u0, sim_time, model, idx, model_bias, magic_factor, x1star);

  % compute state relative to nominal trajectory at next step
  dx1 = compute_dx(xnom1, x1);
  
  
