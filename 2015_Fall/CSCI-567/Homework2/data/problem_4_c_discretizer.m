function [ category_hist, category, division_boundaries ] = problem_4_c_discretizer( array )
sorted = sort(array(~isnan(array)));
n_bins = min(10, numel(unique(sorted)));
elements_per_bin = ceil(length(sorted)/n_bins);
division_boundaries =[];
for i=1:n_bins-1
    division_boundaries(i) = sorted(elements_per_bin*i);
end
category = zeros(length(array),1);
for i=1:n_bins-2
    indices = find(array >= division_boundaries(i) & array < division_boundaries(i+1) &  ~isnan(array) );
    category(indices) = i+1;
    length(indices);
end
indices = find(array<division_boundaries(1) &  ~isnan(array));
category(indices)=1;
length(indices);

indices = find(array>=division_boundaries(n_bins-1) &  ~isnan(array) );
category(indices)=n_bins;
length(indices);

ind = find(isnan(array));
category(ind)=NaN;
length(ind);

category_hist = [];
for i=1:n_bins
    category_hist(i) = length(find(category == i &  ~isnan(category)));
end


end

