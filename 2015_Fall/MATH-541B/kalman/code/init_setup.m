     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

addpath utils_rotations;
addpath DDP
addpath utils_KF_DDP

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a few parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt = .05; % time scale for euler integration
g = 9.81; % gravity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set up idx, model params, model features  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
idx.u_prev = k:k+3; k=k+4;
idx.u_delta_prev = k:k+3; k=k+4;
idx.ned_dot = k:k+2; k=k+3;
idx.ned = k:k+2; k=k+3;
idx.pqr = k:k+2; k=k+3;
idx.q = k:k+3; k=k+4;  % it's critical for compose_dx.m, compute_dx.m (and likely other functions) for the quaternion to be the last entry in the state

% non-state variables used as features in the model:
idx.one = k; k=k+1;
idx.inputs = k:k+3; k=k+4;
idx.uvw = k:k+2; k=k+3;

%% [[tic toc + sweeps data model (20070927)]]

model.params.m = 5; % kg
model.params.Ixx = .3;
model.params.Iyy = .3;
model.params.Izz = .3;
model.params.Ixy = 0; model.params.Ixz = 0; model.params.Iyz = 0;
model.params.I = [model.params.Ixx model.params.Ixy model.params.Ixz;
	model.params.Ixy model.params.Iyy model.params.Iyz;
	model.params.Ixz model.params.Iyz model.params.Izz];


model.params.Tx = [-.086 -3.47  13.20]' * model.params.Ixx;
model.params.Ty = [.015  -3.06   -9.21]' * model.params.Iyy;
model.params.Tz = [-.139 -2.58   14.84]' * model.params.Izz;
model.params.Fx = -.048 * model.params.m;
model.params.Fy = [-0.57  -.12]' * model.params.m;
model.params.Fz = [1.21 -.0005 -27.5]' * model.params.m;


model.features.Tx = [idx.one idx.pqr(1) idx.inputs(1)];
model.features.Ty = [idx.one idx.pqr(2) idx.inputs(2)];
model.features.Tz = [idx.one idx.pqr(3) idx.inputs(3)];

model.features.Fx = [idx.uvw(1)];
model.features.Fy = [idx.one idx.uvw(2)];
model.features.Fz = [idx.one idx.uvw(3) idx.inputs(4)];

