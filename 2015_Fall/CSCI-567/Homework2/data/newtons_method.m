function [ theta_new, grad_train_accu, iterations ] = newtons_method(X_data,y )
n = size(X_data,1);
p = size(X_data,2);
epsilon = 0.00000001;
theta = ones(p,1);
theta_new = zeros(p,1);
iterations = 0;
while norm(theta-theta_new)>epsilon
    theta = theta_new;
    gradient = 1/n * X_data'*(sigmoid(X_data*theta) - y);
    h = hessian(X_data, theta);
    theta_new = theta - pinv(h)*gradient;
    iterations = iterations+1;
end
predictions = sigmoid(X_data*theta_new);
prediction_indices = predictions >0.5;
grad_train_accu = sum(prediction_indices == y);
grad_train_accu = grad_train_accu/length(predictions);

end