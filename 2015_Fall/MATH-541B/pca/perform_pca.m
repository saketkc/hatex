function [eigenvalues, eigenvecs, projected, reconstructed] = perform_pca(X, r)
% input:
%   X - N*D data matrix, each row as a data sample
%       You must assume that the data samples are not zero-mean, thus you need to perform 
%       data transformation on X to make sure that the samples have zero-mean (PCA algorithm assumption),
%       before performing eigenvalue-eigenvector decomposition.
%       You may use MATLAB built-in function 'eig' to perform eigenvalue-eigenvector decomposition.
% output:
%   eigenvalues: D*1 vector
%   eigenvecs: D*D matrix, normalized eigenvectors (with length=1) sorted based on its eigenvalue magnitude, 
%              with d-th column corresponds to eigenvector with the d-th biggest eigenvalue
%              (e.g. 1st column corresponds to eigenvector with the biggest eigenvalue,
%               2nd column corresponds to eigenvector with 2nd biggest eigenvalue, etc.)
%
[N,P] = size(X);
X_normalised = bsxfun(@minus, X, mean(X));
x_n = X_normalised;
XTX = 1/N*X_normalised'*X_normalised;
%XXT = 1/N*X_normalised*X_normalised';
[V,D] = eig(XTX);
%[V,D] = eig(XXT);
% Trick to calculte eigne vectors when number of dimenssamples >> number of dimensions
%V = X_normalised'*V;
[D,I] = sort(diag(D), 'descend');
V = V(:, I);
%[V,D]=eigs(XTX, size(XTX,1),'LA');
colnorm=sqrt(sum(V.^2,1));
V_normalised = bsxfun(@rdivide, V, colnorm);
eigenvecs = V_normalised;
eigenvalues = D;
projected = X_normalised*eigenvecs(:,1:r);
reconstructed = bsxfun(@plus, projected*eigenvecs(:,1:r)', mean(X));
end
