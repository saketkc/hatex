load('hw6_pca.mat')
eigenvecs = get_sorted_eigenvecs(X.train);
[N,D] = size(X.train);
for i=D-8:D
    im = double(reshape(eigenvecs(:,i), 16, 16));
    imwrite(im, sprintf('eig-%d.png', i));
end
