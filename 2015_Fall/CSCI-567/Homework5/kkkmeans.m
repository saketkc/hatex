function [clusters_new] = kkkmeans(data)
%Random initilisation of clusters
k=2;
rows = size(data,1);
kernel = poly_kernel(-5, 1, data);
rows = size(kernel,1);
clusters_old = repmat(1,rows,1);
clusters_new = repmat(1,rows,1);
iterations = 0;

norm_data = sum(data.^2,2);
min_pos = find(norm_data == min(norm_data));
clusters_new(min_pos,:) = 2;
mu2 = sum(data,1)-data(min_pos,:);
mu = [data(min_pos,:);mu2/(rows-1)];

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
