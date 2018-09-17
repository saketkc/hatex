run_problem_4_d;
X_train_main = X_train;
X_test_main  = X_test;
X_train(:,n_cols+1) = sqrt(pclass_train)';
X_train(:,n_cols+2) = sqrt(age_train)';
X_train(:,n_cols+3) = sqrt(sibsp_train)';
X_train(:,n_cols+4) = sqrt(parch_train)';
X_train(:,n_cols+5) = sqrt(fare_train)';


X_test(:,n_cols+1) = sqrt(pclass_test)';
X_test(:,n_cols+2) = sqrt(age_test)';
X_test(:,n_cols+3) = sqrt(sibsp_test)';
X_test(:,n_cols+4) = sqrt(parch_test)';
X_test(:,n_cols+5) = sqrt(fare_test)';


X_train_master = X_train;
X_test_master = X_test;

% sex, pclass, fare, embarked, parch, sibsp, age
% 1,    2,      3,     4-5,     6,      7,    8 
transform = [2,3,6,7,8];
discrete_boundaries = [];
for i=1:length(transform)
    col = transform(i);
    [ category_hist, category, division_boundaries ] = problem_4_c_discretizer( X_train(:, col) );
    discrete_boundaries{col} = division_boundaries';
    X_train_master(:,col) = category;
    
    [category_hist, category_test] =  problem_4_c_discretizer_with_boundaries(X_test(:,col), division_boundaries);
    X_test_master(:,col) = category_test;
end

X_train_before_addition = X_train_master;
X_test_before_addition = X_test_master;

for i=1:length(transform)
    col = transform(i);
    colvalue = X_train_master(:,col);
    colvalue_test = X_test_master(:,col);
    colvalue(isnan(colvalue))=Inf;
    colvalue_test(isnan(colvalue_test))=Inf;

    unique_values = unique(colvalue);
    map = binary_mapper(unique_values);
    mapped_values = [];
    mapped_values_test = [];
    for j=1:length(colvalue)
        mapped_values(j,:) = map(colvalue(j));        
    end
    for j=1:length(colvalue_test)
        mapped_values_test(j,:) = map(colvalue_test(j));
    end
    X_train_master = [X_train_master mapped_values];
    X_test_master = [X_test_master mapped_values_test];
    
    
end


current_cols = size(X_train_master,2);


for i=2:current_cols
    for j=1:i-1
        newcol = X_train_master(:,i).*X_train_master(:,j);
        newcol_test = X_test_master(:,i).*X_test_master(:,j);
        X_train_master = [X_train_master newcol];
        X_test_master = [X_test_master newcol_test];
    end
end


new_cols = size(X_train_master,2);

X_train_master_pruned = X_train_master;
X_test_master_pruned = X_test_master;

n_deleted=0;
for i=1:new_cols
    colvalue = X_train_master(:,i);
    colvalue(isnan(colvalue))=Inf;
    unique_values = unique(colvalue);
    if numel(unique_values)<2
        X_train_master_pruned(:,i-n_deleted)=[];
        X_test_master_pruned(:,i-n_deleted)=[];
        n_deleted=n_deleted+1;
    end
end
        
X_train_master_pruned_mean = nanmean(X_train_master_pruned);
%assert(length(mean)==n_cols);
X_train_master_pruned_std = nanstd(X_train_master_pruned);

X_train_master_pruned_normalised = bsxfun(@minus, X_train_master_pruned, X_train_master_pruned_mean );
X_train_master_pruned_normalised = bsxfun(@rdivide, X_train_master_pruned_normalised, X_train_master_pruned_std);

X_test_master_pruned_normalised = bsxfun(@minus, X_test_master_pruned, X_train_master_pruned_mean );
X_test_master_pruned_normalised = bsxfun(@rdivide, X_test_master_pruned_normalised, X_train_master_pruned_std);


