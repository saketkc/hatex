clear all;
rng(1);
[X,Y] = problem_5_a(10);
rows_X = size(X,1);
cols_X = size(X,2);
beta_matrix = [];
beta_1 = [];
beta_2 = [];
beta_3 = [];
beta_4 = [];
beta_5 = [];

for i=1:rows_X
    beta_1(end+1,:) = estimate_beta(1, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_2(end+1,:) = estimate_beta(2, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_3(end+1,:) = estimate_beta(3, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_4(end+1,:) = estimate_beta(4, X(i,:),Y(i,:)');
end

for i=1:rows_X
    beta_5(end+1,:) = estimate_beta(5, X(i,:),Y(i,:)');
end

efx1 = efx(X,beta_1);
efx2 = efx(X,beta_2);
efx3 = efx(X,beta_3);
efx4 = efx(X,beta_4);
efx5 = efx(X,beta_5);

bias1 = sum(sum((fx(X)-efx1))^2/(rows_X*cols_X);
bias2 = sum(sum(fx(X)-efx2))^2/(rows_X*cols_X);
bias3 = sum(sum(fx(X)-efx3))^2/(rows_X*cols_X);
bias4 = sum(sum(fx(X)-efx4))^2/(rows_X*cols_X);
bias5 = sum(sum(fx(X)-efx5))^2/(rows_X*cols_X);

mse1 =[];
mse2 =[];
mse3=[];
mse4=[];
mse5=[];

mse1 = mse(beta_1,X);
mse2 = mse(beta_2,X);
mse3 = mse(beta_3,X);
mse4 = mse(beta_4,X);
mse5 = mse(beta_5,X);

var1 = variance(beta_1,X,efx1);
var2 = variance(beta_2,X,efx2);
var3 = variance(beta_3,X,efx3);
var4 = variance(beta_4,X,efx4);
var5 = variance(beta_5,X,efx5);

mmse1 = mean(mse1);
mmse2 = mean(mse2);
mmse3 = mean(mse3);
mmse4 = mean(mse4);
mmse5 = mean(mse5);
