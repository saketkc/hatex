function [ theta_new, grad_train_accu, iterations,errors ] = newtons_method(X_data,y , theta_initial)
n = size(X_data,1);
p = size(X_data,2);
epsilon = 0.1;
rand('seed',1);
theta = rand(p,1);%theta_initial;
theta_new = rand(p,1);
delta  = 1;
iterations = 0;
errors = [];
while delta>epsilon
    theta = theta_new;
    error = 1./n * ( -y' * log( sigmoid(X_data * theta) ) - ( 1 - y') * log ( 1 - sigmoid( X_data * theta)) );
    errors(end+1,:) = error;
    gradient = 1./n*X_data'*(sigmoid(X_data*theta) - y);
    h = hessian(X_data, theta);
    theta_new = theta - pinv(h)*gradient;
    iterations = iterations+1;
    delta = norm(theta-theta_new);
end

predictions = sigmoid(X_data*theta_new);
prediction_indices = predictions >=0.5;
grad_train_accu = sum(prediction_indices == y);
grad_train_accu = grad_train_accu/length(predictions);

end
