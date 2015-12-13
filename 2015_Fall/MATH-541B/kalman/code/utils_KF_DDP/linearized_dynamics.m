% Linearizes the dynamics around the state x0 and control position u0
% The system is parametrized in coordinates relative to the position and
% orientation of a state xt0 at the current time, and with respect to
% xt1 at the next time step.
% returns A, B, such that x(t+dt) = A*x(t) + B*u(t)
function [A , B] = linearized_dynamics(x0, u0, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

A = [];
B = [];

dx0 = compute_dx(xt0, x0);
fx_t0 = err_simulate(dx0, u0, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star);

epsilon = ones(1, max(size(dx0))) * .01;
%epsilon(end-4:end-1) = ones(1,4); %% seems better to linearize with large step for the inputs
%%% recall last entry of state corresponds to intercept, do not
%%% linearize!
for i=1:max(size(epsilon))-1
    delta = zeros(size(dx0));
    delta(i) = epsilon(i);
    fx_t1m = err_simulate(dx0 - delta, u0, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star);
    fx_t1p = err_simulate(dx0 + delta, u0, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star);

    A = [ A (fx_t1p - fx_t1m)/epsilon(i)/2 ];
end

epsilon = ones(1,max(size(u0)));
for i=1:max(size(u0))
    delta = zeros(size(u0));
    delta(i) = epsilon(i);

    fx_t1m = err_simulate(dx0, u0 - delta, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star);
    fx_t1p = err_simulate(dx0, u0 + delta, xt0, xt1, simulate_f, dt_sim, model, idx, model_bias, magic_factor, x1star);
    B = [ B (fx_t1p - fx_t1m)/epsilon(i)/2 ];
end

A = [ A  (fx_t0 - A*dx0(1:end-1) - B*u0) ];


