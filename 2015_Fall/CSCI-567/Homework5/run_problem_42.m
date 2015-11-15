clear all;
rng(1);
data = load('hw5_blob.mat');
blob = data.points;

data = load('hw5_circle.mat');
circle = data.points;

K = [2, 3, 5];

for i=1:numel(K)
    k = K(i);
    clusters = kmeans(blob,k);
    scatter(blob(:,1), blob(:,2), [], clusters, 'filled');
    print(sprintf('blob-%d',k), '-dpng');
end


for i=1:numel(K)
    k = K(i);
    clusters = kmeans(circle,k);
    scatter(circle(:,1), circle(:,2), [], clusters, 'filled');
    print(sprintf('circle-%d',k), '-dpng');
end
