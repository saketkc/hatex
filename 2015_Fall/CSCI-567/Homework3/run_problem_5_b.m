clear all;
rng(1);
rows_X =100;
cols_X = 100;
[X,Y] = problem_5_a(rows_X, cols_X);
rows_X = size(X,1);
cols_X = size(X,2);
beta_matrix = [];
beta_1 = [];
beta_2 = [];
beta_3 = [];
beta_4 = [];
beta_5 = [];
beta_6 = [];

for i=1:rows_X
    beta_1(end+1,:) =  1;%ones(rows_X,1);%estimate_beta(1, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_2(end+1,:) = estimate_beta(1, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_3(end+1,:) = estimate_beta(2, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_4(end+1,:) = estimate_beta(3, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_5(end+1,:) = estimate_beta(4, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_6(end+1,:) = estimate_beta(5, X(i,:),Y(i,:)');
end

efx1 = ones(rows_X,cols_X);%efx(X,beta_1);
efx2 = efx(X,beta_2);
efx3 = efx(X,beta_3);
efx4 = efx(X,beta_4);
efx5 = efx(X,beta_5);
efx6 = efx(X,beta_6);

bias1 = bias(beta_1,X,efx1);
bias2 = bias(beta_2,X,efx2);
bias3 = bias(beta_3,X,efx3);
bias4 = bias(beta_4,X,efx4);
bias5 = bias(beta_5,X,efx5);
bias6 = bias(beta_6,X,efx6);

mse1 = mse(beta_1,X);
mse2 = mse(beta_2,X);
mse3 = mse(beta_3,X);
mse4 = mse(beta_4,X);
mse5 = mse(beta_5,X);
mse6 = mse(beta_6,X);

var1 = variance(beta_1,X,efx1);
var2 = variance(beta_2,X,efx2);
var3 = variance(beta_3,X,efx3);
var4 = variance(beta_4,X,efx4);
var5 = variance(beta_5,X,efx5);
var6 = variance(beta_6,X,efx6);

mmse1 = mean(mse1);
mmse2 = mean(mse2);
mmse3 = mean(mse3);
mmse4 = mean(mse4);
mmse5 = mean(mse5);
mmse6 = mean(mse6);

mvar1 = mean(var1);
mvar2 = mean(var2);
mvar3 = mean(var3);
mvar4 = mean(var4);
mvar5 = mean(var5);
mvar6 = mean(var6);


mbias1 = mean(bias1);
mbias2 = mean(bias2);
mbias3 = mean(bias3);
mbias4 = mean(bias4);
mbias5 = mean(bias5);
mbias6 = mean(bias6);


disp('-----g1-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse1,mbias1,mvar1));
hist(mse1);
title('g1 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g11-mse.png','-dpng');
close all;


disp('-----g2-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse2,mbias2,mvar2));
hist(mse2);
title('g2 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g21-mse.png','-dpng');
close all;


disp('-----g3-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse3,mbias3,mvar3));
hist(mse3);
title('g3 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g31-mse.png','-dpng');
close all;


disp('-----g4-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse4,mbias4,mvar4));
hist(mse4);
title('g4 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g41-mse.png','-dpng');
close all;


disp('-----g5-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse5,mbias5,mvar5));
hist(mse5);
title('g5 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g51-mse.png','-dpng');
close all;


disp('-----g6-------');
disp(sprintf('MSE:%f\tBias Sq:%f\tVariance:%f',mmse6,mbias6,mvar6));
hist(mse6);
title('g6 MSE');
xlabel('MSE');
ylabel('Frequency');
print('g61-mse.png','-dpng');
close all;


