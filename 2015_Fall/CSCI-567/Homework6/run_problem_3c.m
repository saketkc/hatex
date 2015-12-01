load('hw6_pca.mat')
eigenvecs = get_sorted_eigenvecs(X.train);
[N,D] = size(X.train);
K = [1, 5, 10, 20, 80];
mu = mean(X.train);
indices = [5500, 6500, 7500, 8000, 8500];
%x=double(reshape(X.train(5438,:), 16, 16))
for i=1:numel(indices)
    n = indices(i);
        orig = double(reshape(X.train(n,:), 16, 16));
        imwrite(orig, sprintf('3c-orig-%d.png', n));
    for j=1:numel(K)
        k = K(j);
        X_compressed = X.train * eigenvecs(:,1:k);
        X_reconstructed = X_compressed*eigenvecs(:,1:k)';
        y_t = double(reshape(X_reconstructed(n,:)+mu, 16, 16));
        imwrite(y_t, sprintf('3c-%d-%d.png', n, k));
    end
end
