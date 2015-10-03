run_problem_4_d;
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



[ category_hist, category, division_boundaries ] = problem_4_c_discretizer( X_train(:, 1) );
