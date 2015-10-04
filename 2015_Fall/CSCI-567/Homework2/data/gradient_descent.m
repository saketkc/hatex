function [ theta_new, grad_train_accu, iterations ] = gradient_descent(alpha, X_data,y )
n = size(X_data,1);
p = size(X_data,2);
epsilon = 0.001;
theta = zeros(p,1);
theta_new = ones(p,1);
iterations = 0;
while norm(theta-theta_new)>epsilon
    theta = theta_new;
    gradient = 1/n * X_data'*(sigmoid(X_data*theta) - y);
    size(gradient);
    theta_new = theta - alpha*gradient;
    iterations = iterations+1;
end
predictions = sigmoid(X_data*theta_new);

prediction_indices = predictions >=0.5;

grad_train_accu = sum(prediction_indices == y);
grad_train_accu = grad_train_accu/length(predictions);

end