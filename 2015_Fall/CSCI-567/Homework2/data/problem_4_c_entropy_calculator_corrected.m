function [ HY, HY_X ] = problem_4_c_entropy_calculator_corrected(category_array, survival_train)

survival_yes_indices = find(survival_train(survival_train == '1'));
survival_no_indices  = find(survival_train(survival_train == '0'));

survival_yes_p = length(survival_yes_indices)/length(survival_train);
survival_no_p = length(survival_no_indices)/length(survival_train);

isc = iscell(category_array);
if (isc)    
    include = ~cellfun(@isempty,category_array);
    category_array_clean = category_array(include);
else
    category_array_clean = category_array(~isnan(category_array));
end

unique_categories = unique(category_array_clean);
n_bins = numel(unique_categories);
total_counts = length((category_array_clean));

HY_X = 0;
HY = -(survival_yes_p*log2(survival_yes_p)+survival_no_p*log2(survival_no_p));


for i=1:n_bins
    bin = unique_categories(i);
    if ~isc
        category_indices = find(category_array == bin &  ~isnan(category_array));
    else
        category_indices = cellfun(@(x) isequal(x, bin) & ~isempty(x), category_array);
    end
    survival_subarray = survival_train(category_indices);
    survival_yes_indices = find(survival_subarray(survival_subarray == '1'));
    survival_no_indices = find(survival_subarray(survival_subarray == '0'));
    
    category_p = length(category_indices)/total_counts;
    
    survival_yes_p = length(survival_yes_indices)/length(survival_subarray);
    survival_no_p = length(survival_no_indices)/length(survival_subarray);
    if survival_yes_p>0 & survival_no_p>0
        HY_X = HY_X - category_p*(survival_yes_p*log2(survival_yes_p)+survival_no_p*log2(survival_no_p) );
    end
    
end


end