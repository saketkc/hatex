function [ train_accu ] = glmfit_accu( data, label )
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here

b = glmfit(data, label,'binomial','link','logit');
yfit_train = glmval(b,data,'logit');


yfit_train_indices = yfit_train >=0.5;
train_accu = sum(yfit_train_indices == label);
train_accu = train_accu/length(yfit_train);


end

