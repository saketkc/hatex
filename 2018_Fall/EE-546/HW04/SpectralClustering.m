function [idx1, idx2, idx3] = SpectralClustering(gamma, k, X)
    K = zeros(size(X, 1), size(X, 1));
    for i=1:size(X,1)
        for j=1:size(X,1)
            K(i,j) = exp(-gamma* (norm( X(i, :) - X(j, :), 2).^2) );
        end
    end
    K_maxk = maxk(K, k);
    W = K;
    for i=1:size(X,1)
        for j=1:size(X,1)
            if K(i,j) < min(K_maxk(:, j))
                W(i,j) = 0;
            end
        end
    end
    W = (W+transpose(W))/2;
    D = diag(W*ones(size(W,1),1));
    I = eye(size(W,1));
    laplacian_unnormalized = D-W;
    laplacian_normalized = I-W;
    laplacian_rw = I-inv(D)*W;
    [V1, D1] = eigs(laplacian_unnormalized, k);
    [V2, D2] = eigs(laplacian_normalized, k);
    [V3, D3] = eigs(laplacian_rw, k);


    V1_row_norm = sqrt(sum(V1.^2,2));
    Y1 = bsxfun(@rdivide, V1, V1_row_norm);

    V2_row_norm = sqrt(sum(V2.^2,2));
    Y2 = bsxfun(@rdivide, V2, V2_row_norm);

    V3_row_norm = sqrt(sum(V3.^2,2));
    Y3 = bsxfun(@rdivide, V3, V3_row_norm);

    idx1 = kmeans(Y1, k);
    idx2 = kmeans(Y2, k);
    idx3 = kmeans(Y3, k);
end