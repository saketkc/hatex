function [ HY, HX_Y ] = problem_4_c_entropy_calculator(category_array, survival_train)

survival_yes_indices = find(survival_train(survival_train == '1'));
survival_no_indices  = find(survival_train(survival_train == '0'));

survival_yes_p = length(survival_yes_indices)/length(survival_train);
survival_no_p = length(survival_no_indices)/length(survival_train);


isc = iscell(category_array);
if (isc)
    category_array_clean = [];
    include = ~cellfun(@isempty,category_array);
    %for i=1:length(include)
    %    if include(i) == 1
    %        category_array_clean(end+1) = category_array{i};
    %    end
    %end
    category_array_clean = category_array(include);
else
    category_array_clean = category_array(~isnan(category_array));
end
unique_categories = unique(category_array_clean);
n_bins = numel(unique(category_array_clean));
total_counts = length((category_array_clean));
h=0;

isc = iscell(category_array_clean);

category_yes_subarray = category_array(survival_yes_indices);
category_no_subarray = category_array(survival_no_indices);

HX_Y = 0;
HY = -(survival_yes_p*log2(survival_yes_p)+survival_no_p*log2(survival_no_p));

for i=1:n_bins
    bin = unique_categories(i);
    if ~isc

    category_yes_indices = find(category_yes_subarray == bin &  ~isnan(category_yes_subarray));
    category_no_indices = find(category_no_subarray == bin &  ~isnan(category_no_subarray));
    else
        category_yes_indices = cellfun(@(x) isequal(x, bin), category_yes_subarray);
        category_no_indices = cellfun(@(x) isequal(x, bin), category_no_subarray);

    end

    category_yes_p  = length(category_yes_indices)/total_counts;
    category_no_p  = length(category_no_indices)/total_counts;
    if (category_yes_p>0 & category_no_p >0)
        HX_Y = HX_Y-survival_yes_p*(category_yes_p*log2(category_yes_p))-survival_no_p*(category_no_p*log2(category_no_p));
    end
end

end