clf;
clear all;
rng(100);
time = 200;

%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%
m = 1;
c = 0;
k = 1;
b = 1;

sigma2 = 0.01;
alpha2 = 0.01;
beta2 = 0.01;
rho2 = 0.01;

tau = 1;
omega = sqrt(k/m);

y0=0.1;
y1=0.1;
ualpha = 0.1;

amplitude = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%Variable Init%%%%%%%%%%%%%%
A = [0 1; -k/m -c/m];
B = [0;b/m];
C = [1 0];

% Covar matrix of x[0]
Q  = [alpha2 0 ; 0 beta2];



phi = expm(A*tau);
psi = pinv(A)*(phi-eye(2))*B;
V = sigma2*psi*psi';

x_predicted = {};
x_updated = {};
x_observed = {};
y_observed = {};

P_predicted = {};
P_updated = {};

P_predicted{1} = sqrt(Q);

x_observed{1} = [y0;y1] + mvnrnd([0;0], sqrt(Q))';
x_predicted{1} = [y0;y1] + mvnrnd([0;0], sqrt(Q))';

y_observed{1} = C*x_observed{1} + normrnd(0,sqrt(rho2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = [];
xd = [];
x(end+1) = x_predicted{1}(1);
xd(end+1) = x_predicted{1}(2);
u = [];
for k=1:time
    
    uk = amplitude*sin(ualpha*k*tau);
    vk = mvnrnd([0;0], sqrt(V))';
    wk = normrnd(0,sqrt(rho2));
    W_k = rho2 * eye(2);
    %%%%%%%%%% Prediction Start %%%%%%%%%%%%%%%%%%
    x_predicted{k+1} = phi * x_predicted{k} + psi*uk;
    P_predicted{k+1} = phi * P_predicted{k} * phi' + V;
    %%%%%%%%%% Prediction End  %%%%%%%%%%%%%%%%%%%

    %%%%%%%%%% Observation Start %%%%%%%%%%%%%%%%%%
    x_observed{k+1}  =  phi * x_observed{k} + psi*uk + vk;
    y_observed{k+1} = C* x_observed{k} + wk;
    %%%%%%%%%% Observation End %%%%%%%%%%%%%%%%%%

    %%%%%%%%%% Update Start %%%%%%%%%%%%%%%%%%
    K_2 = P_predicted{k+1}* C' * pinv(C * P_predicted{k+1} * C'+ wk);
    x_predicted{k+1} = x_predicted{k+1} + K_2*(y_observed{k+1}-C*x_predicted{k+1});
    P_predicted{k+1} = P_predicted{k+1} - K_2*C*P_predicted{k+1};
    %%%%%%%%%% Update End   %%%%%%%%%%%%%%%%%%

    x(end+1) = x_predicted{k+1}(1);
    xd(end+1) = x_predicted{k+1}(2);

end

plot(1:time+1, cell2mat(y_observed), 1:time+1, (x));
%plot(1:time+1,x);% cell2mat(y_observed));%, 1:time+1, (x));
%plot(1:time+1, cell2mat(y_observed));%, 1:time+1, (x));
legend('Observed');%, 'Predicted');
legend('Observed', 'Predicted');
print('kalman-y', '-dpng');
