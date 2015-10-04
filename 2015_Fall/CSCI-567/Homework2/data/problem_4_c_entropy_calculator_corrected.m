function [ HY, HY_X ] = problem_4_c_entropy_calculator_corrected(category_array, survival_train)

isc = iscell(category_array);
if (isc)    
    include = ~cellfun(@isempty,category_array);
    category_array_clean = category_array(include);
else
    include = ~isnan(category_array);
    category_array_clean = category_array(include);
end

unique_categories = unique(category_array_clean);
n_bins = numel(unique_categories);
total_counts = length((category_array_clean));

survival_clean =  survival_train(include);
survival_yes_indices_clean =  find(survival_clean(survival_clean == '1'));
survival_no_indices_clean =  find(survival_clean(survival_clean == '0'));


survival_yes_p_clean =  length(survival_yes_indices_clean)/length(survival_clean);
survival_no_p_clean =  length(survival_no_indices_clean)/length(survival_clean);

HY_X = 0;
if survival_no_p_clean<=0
    HY=-survival_yes_p_clean*log2(survival_yes_p_clean);
elseif survival_yes_p_clean<=0
    HY=-survival_no_p_clean*log2(survival_no_p_clean);
else
    HY = -(survival_yes_p_clean*log2(survival_yes_p_clean)+survival_no_p_clean*log2(survival_no_p_clean));

end


for i=1:n_bins
    bin = unique_categories(i);
    if ~isc
        category_indices = find(category_array_clean == bin &  ~isnan(category_array_clean));
    else
        category_indices = cellfun(@(x) isequal(x, bin) & ~isempty(x), category_array_clean);
    end
    survival_subarray = survival_clean(category_indices);
    survival_yes_indices = find(survival_subarray(survival_subarray == '1'));
    survival_no_indices = find(survival_subarray(survival_subarray == '0'));
    
    category_p = length(category_indices)/total_counts;
    
    survival_yes_p = length(survival_yes_indices)/length(survival_subarray);
    survival_no_p = length(survival_no_indices)/length(survival_subarray);
    if survival_yes_p<=0
        HY_X = HY_X - category_p*(survival_no_p*log2(survival_no_p) );
    elseif survival_no_p <=0        
        HY_X = HY_X - category_p*(survival_yes_p*log2(survival_yes_p));        
    elseif survival_yes_p>0 & survival_no_p >0
        HY_X = HY_X - category_p*( survival_yes_p*log2(survival_yes_p) + survival_no_p*log2(survival_no_p) );
    end
    HY_X;
    
end


end