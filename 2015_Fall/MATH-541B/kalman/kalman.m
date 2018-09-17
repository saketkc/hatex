clf;
clear all;
rng(100);
time = 100;

%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%
m = 1;
c = 1;
k = 1;
b = 1;

sigma2 = 2;
alpha2 = 0.01;
beta2 = 0.01;
rho2 = 2;

tau = 1;

y0=0.1;
y1=0.1;
ualpha = sqrt(k/m);

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
x_p =[];
xd_p =[];
x_u = [];
xd_u = [];
x_o = [];
xd_o = [];


x_p(end+1) = x_predicted{1}(1);
xd_p(end+1) = x_predicted{1}(2);
x_u(end+1) = x_predicted{1}(1);
xd_u(end+1) = x_predicted{1}(2);
x_o(end+1) = x_predicted{1}(1);
xd_o(end+1) = x_predicted{1}(2);


u = [];
vary1 = [];
vary2 = [];
vary1(end+1) = P_predicted{1}(1,1);
vary2(end+1) = P_predicted{1}(2,2);

for k=1:time
    uk = amplitude*sin(ualpha*k*tau);
    vk = mvnrnd([0;0], sqrt(V))';
    wk = normrnd(0,sqrt(rho2));
    W_k = rho2 * eye(2);
    %%%%%%%%%% Prediction Start %%%%%%%%%%%%%%%%%%
    x_predicted{k+1} = phi * x_predicted{k} + psi*uk;
    P_predicted{k+1} = phi * P_predicted{k} * phi' + V;
    %%%%%%%%%% Prediction End  %%%%%%%%%%%%%%%%%%%
    x_p(end+1) = x_predicted{k+1}(1);
    xd_p(end+1) = x_predicted{k+1}(2);

    %%%%%%%%%% Observation Start %%%%%%%%%%%%%%%%%%
    x_observed{k+1}  =  phi * x_observed{k} + psi*uk + vk;
    y_observed{k+1} = C* x_observed{k} + wk;
    %%%%%%%%%% Observation End %%%%%%%%%%%%%%%%%%
    x_o(end+1) = x_observed{k+1}(1);
    xd_o(end+1) = y_observed{k+1};


    %%%%%%%%%% Update Start %%%%%%%%%%%%%%%%%%
    K_2 = P_predicted{k+1}* C' * pinv(C * P_predicted{k+1} * C'+ rho2);
    x_predicted{k+1} = x_predicted{k+1} + K_2*(y_observed{k+1}-C*x_predicted{k+1});
    P_predicted{k+1} = P_predicted{k+1} - K_2*C*P_predicted{k+1};
    %%%%%%%%%% Update End   %%%%%%%%%%%%%%%%%%

    vary1(end+1) = P_predicted{k+1}(1,1);
    vary2(end+1) = P_predicted{k+1}(2,2);


    x_u(end+1) = x_predicted{k+1}(1);
    xd_u(end+1) = x_predicted{k+1}(2);

end


% Defaults for this blog post
width = 20;     % Width in inches
height = 10;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 14;      % Fontsize
lw = 2.5;      % LineWidth
msz = 38;       % MarkerSize



set(gcf,'defaultLineLineWidth',lw);   % set the default line width to lw
set(gcf,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(gcf,'defaultLineLineWidth',lw);   % set the default line width to lw
set(gcf,'defaultLineMarkerSize',msz); % set the default line marker size to msz


% Here we preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties




plot(1:time+1, (x_o), 1:time+1, (x_p), 1:time+1, x_u);
xlabel('Time');
ylabel('Position');
title('Position v/s Time');
h_legend = legend('Observed', 'Predicted', 'Updated');
set(h_legend,'FontSize',14);i
%set(h_legend,'position',[-10 -10 0.2 0.2])
%p = get(h_legend,'Position'); p(3)=p(3)*1;
%set(h_legend, 'Position',p);
f = findobj('type', 'line');
set(f(2), 'XData', [.6, 0.9]); % Changes line three
set(f(4), 'XData', [.6, 0.9]); % Changes line three
set(f(6), 'XData', [.6, 0.9]); % Changes line three
print('kalman-position-m1h', '-dpng');


close all;
plot(1:time+1, (xd_o), 1:time+1, (xd_p), 1:time+1, xd_u);
xlabel('Time');
ylabel('Velocity');
title('Velocity v/s Time');
legend('Observed', 'Predicted', 'Updated')
%f = findobj('type', 'line');
%set(f(2), 'XData', [.6, 0.9]); % Changes line three
%set(f(4), 'XData', [.6, 0.9]); % Changes line three
%set(f(6), 'XData', [.6, 0.9]); % Changes line three
print('kalman-velocity-m1h', '-dpng');

plot(1:time+1, vary1);
xlabel('Time');
ylabel('Position Variance');
title('Position Variance v/s Time');
print('kalman-variance1-m1h', '-dpng');


plot(1:time+1, vary2);
xlabel('Time');
ylabel('Velocity Variance');
title('Velocity Variance v/s Time');
print('kalman-variance2-m1h', '-dpng');
