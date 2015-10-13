clear all;
rng(1);
[X,Y] = problem_5_a(100);
rows_X = size(X,1);
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

