%run_problem_4_d;
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
%% Appended square root columns

X_train_master = X_train;
X_test_master = X_test;

% sex, pclass, fare, embarked, parch, sibsp, age
% 1,    2,      3,     4-5,     6,      7,    8 

%% Add swrt -> Discretize numerical variables(in this tranform) -> Append only the dummy variables
transform = [2,3,6,7,8];
discrete_boundaries = [];
for i=1:length(transform)
    col = transform(i);
    undiscretized_col = X_train(:, col);
    %category = X_train(:, col);
    %category_test = X_test(:, col);
    undiscretized_col_test = X_test(:, col);
    [ category_hist, category, division_boundaries ] = problem_4_c_discretizer(undiscretized_col);
    [category_hist, category_test] =  problem_4_c_discretizer_with_boundaries(undiscretized_col_test, division_boundaries);
    %disp(numel(unique(undiscretized_col)));
    category(isnan(category))=Inf;
    unique_values = unique(category);
    %disp(sprintf('%d\t %d',col,numel(unique_values)));
    %disp(unique_values);
    map = binary_mapper(unique_values);

    category_test(isnan(category_test))=Inf;


    mapped_values = [];
    mapped_values_test = [];
    for j=1:length(category)
        mapped_values(j,:) = map(category(j));
    end
    for j=1:length(category_test)
        mapped_values_test(j,:) = map(category_test(j));
    end
    X_train_master = [X_train_master mapped_values];
    X_test_master = [X_test_master mapped_values_test];
end

X_train_nocross = X_train_master;
X_test_nocross = X_test_master;




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

ccol = size(X_train_master_pruned_normalised,2);
disp(sprintf('Total Number of columns: %d', ccol));
