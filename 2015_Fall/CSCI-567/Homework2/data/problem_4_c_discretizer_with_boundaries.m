function [ category_hist, category] = problem_4_c_discretizer_with_boundaries( array, division_boundaries )
%sorted = sort(array(~isnan(array)));
%n_bins = min(10, numel(unique(sorted)));
n_bins = length(division_boundaries)+1;
    
%elements_per_bin = ceil(length(sorted)/n_bins);
category = zeros(length(array),1);
for i=1:n_bins-2
    indices = find(array > division_boundaries(i) & array <= division_boundaries(i+1) &  ~isnan(array) );
    category(indices) = i+1;
    length(indices);
end
indices = find(array<=division_boundaries(1) &  ~isnan(array));
category(indices)=1;
length(indices);

indices = find(array>division_boundaries(n_bins-1) &  ~isnan(array) );
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

