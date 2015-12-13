function [x1, F_ned, T_xyz] = f_heli(x0, delta_u0, sim_time, model, idx, model_bias, magic_factor, x1_star)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

dt = sim_time;   

x1 = zeros(size(x0));

%% for our feedback controllers it's important to have past inputs and
%% change in inputs stored into the state:
x1(idx.u_prev) = x0(idx.u_prev) + delta_u0; % control at previous time, namely at time 0
x1(idx.u_delta_prev) = delta_u0;

%% position and orientation merely require integration (we use Euler
%% integration):
x1(idx.ned) = x0(idx.ned) + dt * x0(idx.ned_dot);
x1(idx.q) = quat_multiply(x0(idx.q)', quaternion_from_axis_rotation(x0(idx.pqr)*dt));

%% augment x0 with necessary model.features to make predictions of the
%% forces and torques, which will allow us to compute linear and angular
%% velocity

x0(idx.one) = 1;
x0(idx.inputs) = x1(idx.u_prev);
x0(idx.uvw) = express_vector_in_quat_frame(x0(idx.ned_dot), x0(idx.q));

%% we assume all forces act through the center of gravity of the
%% helicopter, this is a good enough approximation in current heli
%% configuration [when not true anymore, we should split up forces
%% according to where they act upon the helicopter]

Fxyz_minus_g(1,1) = x0(model.features.Fx)' * model.params.Fx;
Fxyz_minus_g(2,1) = x0(model.features.Fy)' * model.params.Fy;
Fxyz_minus_g(3,1) = x0(model.features.Fz)' * model.params.Fz;

F_ned_minus_g = rotate_vector(Fxyz_minus_g, x0(idx.q));
F_ned = F_ned_minus_g + model.params.m * [0;0;9.81];

if(nargin >=6)
	F_ned = F_ned + model_bias(1:3);
end

x1(idx.ned_dot) = x0(idx.ned_dot) + dt * F_ned / model.params.m;

Tx = x0(model.features.Tx)' * model.params.Tx;
Ty = x0(model.features.Ty)' * model.params.Ty;
Tz = x0(model.features.Tz)' * model.params.Tz;

if(nargin >=6)
	Tx = Tx + model_bias(4);
	Ty = Ty + model_bias(5);
	Tz = Tz + model_bias(6);
end
T_xyz = [Tx; Ty; Tz];
%% simple angular rate simulation [assumes no coupling between axes, works fine for
%% current heli]
pqr_dot = [Tx/model.params.Ixx; Ty/model.params.Iyy; Tz/model.params.Izz];

%%% the physically complete simulation would be:
% T = ( pqr cross ( I pqr ) ) + I pqr_dot;
% pqr_dot = pinv(model.I)* ( Txyz - cross_product(x0(idx.pqr), model.I*x0(idx.pqr)));

x1(idx.pqr) = x0(idx.pqr) + dt * pqr_dot;

if(nargin >= 8) % we provided the magic_factor and x1_star
	x1 = magic_factor*x1_star + (1-magic_factor)*x1;
end

