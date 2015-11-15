function [clusters_new] = kmeans(data, k)
%Random initilisation of clusters
rows = size(data,1);
clusters_old = repmat(3,rows,1);
clusters_new = repmat(5,rows,1);
initial_indices = randi([1 rows], 1, k);
%mu = datasample(data, k, 'Replace', false);
mu = data(initial_indices, :);
iterations = 0;
while any(clusters_old~=clusters_new)
    distances = pdist2(data, mu);
    [M, I] = min(distances, [], 2);
    clusters_old = clusters_new;
    clusters_new = I;
    for (j = 1:k)
        indices = find(clusters_new == j);
        mu(j,:) = sum(data(indices,:),1)/length(indices);
    end
    iterations = iterations+1;
end
iterations;
end
