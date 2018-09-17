function [clusters] = kernelkmeans(circle)
K = 2;
%Random initilisation of clusters
kernel = rbf_kernel(0.1, circle);
%kernel = poly_kernel(-5, 1, circle);
rows = size(kernel,1);
clusters_old = repmat([0 1], rows, 1);
clusters_new = repmat([1 0], rows, 1);
distances = zeros(rows, K);

norm_data = sum(circle.^2,2);
min_pos = find(norm_data == min(norm_data));
clusters_new(min_pos,:) = [0 1];
iterations = 0;
c_old = clusters_old * [1;2];
c_new = clusters_new * [1;2];

while any(c_old~=c_new)
    cluster_count = sum(clusters_new,1);
    for j=1:K;
        Kjj = clusters_new(:,j)*clusters_new(:,j)';
        nk = cluster_count(j);
        Kii = diag(kernel);
        Kij = sum(repmat(clusters_new(:,j)',rows,1).*kernel,2);
        Kjk = sum(sum((Kjj).*kernel));
        distances(:,j) = Kii - (2/nk) * Kij + 1/(nk^2) * Kjk;
    end
    clusters_old = clusters_new;
    min_distances = min(distances, [], 2);
    clusters_new = 1.0*(distances == repmat(min_distances, 1, K));
    size(clusters_new);
    c_old = clusters_old * [1;2];
    c_new = clusters_new * [1;2];
    iterations = iterations+1
end
iterations;
clusters = clusters_new * [1;2];
end
