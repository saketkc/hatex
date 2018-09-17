clear all;
load('hw6_pca.mat')
eigenvecs_train = get_sorted_eigenvecs(X.train);
eigenvecs_test = get_sorted_eigenvecs(X.test);
[N,D] = size(X.train);
K = [1, 5, 10, 20, 80. 256];
mu = mean(X.train);
indices = [5500, 6500, 7500, 8000, 8500];
%x=double(reshape(X.train(5438,:), 16, 16))
for j=1:numel(K)
    k = K(j);
    X_compressed_train = X.train * eigenvecs_train(:,1:k);
    X_reconstructed_train = X_compressed_train*eigenvecs_train(:,1:k)';
    
    X_compressed_test = X.test * eigenvecs_test(:,1:k);
    X_reconstructed_test = X_compressed_test*eigenvecs_test(:,1:k)';

    tic;
    tree = ClassificationTree.fit(X_reconstructed_train, y.train, 'SplitCriterion', 'deviance');
    train_label_inferred = predict(tree, X_reconstructed_train);
    test_label_inferred = predict(tree, X_reconstructed_test);
    accu_train = sum(train_label_inferred == y.train)/numel(y.train);
    accu_test = sum(test_label_inferred == y.test)/numel(y.test);
    msg = sprintf('#PC = %d\t Training Accuracy = %f\t Testing Accuracy = %f\t Time = %f', k, accu_train, accu_test, toc);
    disp(msg);
end
