load('hw6_pca.mat')
eigenvecs = get_sorted_eigenvecs(X.train);
[N,D] = size(X.train);
x=double(reshape(X.train(5438,:), 16, 16))
imwrite(x, 'test.png');
for i=1:8
    im = double(reshape(eigenvecs(:,i), 16, 16));
    imwrite(im, sprintf('eig-%d.png', i));
end
