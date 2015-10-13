clear all;
rng(1);
[X,Y] = problem_5_a(100);
rows_X = size(X,1);
beta_matrix = [];
beta_0 = [];
beta_1 = [];
beta_2 = [];
beta_3 = [];
beta_4 = [];
beta_5 = [];
beta_6 = [];

for i=1:rows_X
    beta_1(end+1,:) = estimate_beta(1, X(i,:),Y(i,:)');
end
