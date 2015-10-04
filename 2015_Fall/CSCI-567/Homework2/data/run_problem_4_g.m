%clear all;
%run_problem_4_f;
X_a = [X_train_master_pruned_normalised train_label'];
%X_clean = X_clean(:,any(~isnan(X_clean)));  % for columns
%X_clean = X_clean(any(~isnan(X_clean),2),:);   %for rows
X_indices = find(~isnan(X_a*zeros(size(X_a,2),1)));

X_clean = X_a(X_indices,:);
n = size(X_clean,1);
p = size(X_clean,2);
train_label_clean = X_clean(:,p);
X_input = [ones(n,1) X_clean(:,1:p-1)];

alpha=0.001;
[theta, grad_train_accu, iterations]=gradient_descent(alpha,X_input, train_label_clean);

glmfit_train_accu = 0;

glm_b = glmfit(X_clean(:,1:p-1),train_label_clean,'binomial','link', 'logit');
glm_predict = glmval(glm_b,X_clean(:,1:p-1),'logit');

glm_indices = glm_predict>=0.5;
glm_train_accu = sum(glm_indices == train_label_clean);
glm_train_accu = glm_train_accu/length(glm_predict);