clear all;
%pclass_dict = {'1', '2', '3'};
sex_dict = {'female', 'male'};
embarked_dict = {'C', 'Q', 'S'};
%pclass_map =  dummy_mapper(pclass_dict);
%sex_map = dummy_mapper(sex_dict);
%embarked_map = dummy_mapper(embarked_dict);

%%pclass_map =  binary_mapper(pclass_dict);
sex_map = binary_mapper(sex_dict);
embarked_map = binary_mapper(embarked_dict);


% sex, pclass, fare, embarked, parch, sibsp, age
run_problem_4_a;

embarked_train{cellfun(@isempty,embarked_train)}='S';
fare_train(isnan(fare_train))=33.2955;

embarked_test{cellfun(@isempty,embarked_test)}='S';
fare_test(isnan(fare_test))=33.2955;

X = [];
n_cols = 1+1+1+2+1+1+1;
%n_cols = 2+2-1+1+2+1+1+1;


X_train = [];
for j=1:length(survival_train)
    %sex_map(char(sex_train(j)))
    %pclass_map(int2str(pclass_train(j)))
    s = sex_map(char(sex_train(j)));
    %length(s)
    %%p = pclass_map(int2str(pclass_train(j)));
    %length(p)
    e = embarked_map(char(embarked_train(j)));
    mappedfeatures = [s(:)' pclass_train(j)  fare_train(j) e(:)' parch_train(j) sibsp_train(j) age_train(j)];
    length(mappedfeatures);
    X_train(end+1,1:n_cols) = mappedfeatures;
end

X_test = [];

for j=1:length(survival_test)
    s = sex_map(char(sex_test(j)));
    %%p = pclass_map(int2str(pclass_test(j)));
    e = embarked_map(char(embarked_test(j)));
    mappedfeatures = [s(:)' pclass_test(j)  fare_test(j) e(:)' parch_test(j) sibsp_test(j) age_test(j)];
    X_test(end+1,1:n_cols) = mappedfeatures;
end

X_train_mean = nanmean(X_train);
%assert(length(mean)==n_cols);
X_train_std = nanstd(X_train);

X_train_normalised = bsxfun(@minus, X_train, X_train_mean );
X_train_normalised = bsxfun(@rdivide, X_train_normalised, X_train_std);

X_test_normalised = bsxfun(@minus, X_test, X_train_mean );
X_test_normalised = bsxfun(@rdivide, X_test_normalised, X_train_std);

X_train_normalised_stripped = X_train_normalised(:, 1:n_cols-1);
X_test_normalised_stripped = X_test_normalised(:, 1:n_cols-1);

train_label = [];
test_label = [];
for j=1:length(survival_train)
    train_label(j) = str2num(survival_train(j));
end

for j=1:length(survival_test)
    test_label(j) = str2num(survival_test(j));
end


b = glmfit(X_train_normalised, train_label','binomial','link','logit');
b_stripped = glmfit(X_train_normalised_stripped, train_label','binomial','link','logit');

yfit_train = glmval(b,X_train_normalised,'logit');
yfit_train_stripped = glmval(b_stripped, X_train_normalised_stripped, 'logit');

yfit_test = glmval(b,X_test_normalised,'logit');
yfit_test_stripped = glmval(b_stripped, X_test_normalised_stripped, 'logit');

yfit_train_indices = yfit_train >=0.5;
yfit_train_stripped_indices = yfit_train_stripped >=0.5;
yfit_test_indices = yfit_test >=0.5;
yfit_test_stripped_indices = yfit_test_stripped >=0.5;


train_accu = sum(yfit_train_indices == train_label');
train_accu = train_accu/length(yfit_train);

train_stripped_accu = sum(yfit_train_stripped_indices == train_label');
train__stripped_accu = train_stripped_accu/length(yfit_train_stripped);

test_accu = sum(yfit_test_indices == test_label');
test_accu = test_accu/length(yfit_test);

test_accu_stripped = sum(yfit_test_stripped_indices == test_label');
test_accu_stripped = test_accu_stripped/length(yfit_test_stripped);


age_test_data = X_test(:,n_cols);
mean_age_train = X_train_mean(n_cols);

age_test_data(isnan(age_test_data)) = mean_age_train;

X_test(:, n_cols) = age_test_data;

X_test_normalised = bsxfun(@minus, X_test, X_train_mean );
X_test_normalised = bsxfun(@rdivide, X_test_normalised, X_train_std);
X_test_normalised_stripped = X_test_normalised(:, 1:n_cols-1);


yfit_test = glmval(b,X_test_normalised,'logit');
yfit_test_stripped = glmval(b_stripped, X_test_normalised_stripped, 'logit');

yfit_test_indices = yfit_test >=0.5;
yfit_test_stripped_indices = yfit_test_stripped >=0.5;

subs_test_accu = sum(yfit_test_indices == test_label');
subs_test_accu = subs_test_accu/length(yfit_test);

subs_test_accu_stripped = sum(yfit_test_stripped_indices == test_label');
subs_test_accu_stripped = subs_test_accu_stripped/length(yfit_test_stripped);
