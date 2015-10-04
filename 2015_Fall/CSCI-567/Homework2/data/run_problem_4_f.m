run_problem_4_e;
selected_features = [];
features = 1:size(X_train_master_pruned_normalised,2);
features_array = [];
for j=1:length(survival_train)
    train_label(j) = str2num(survival_train(j));
end
for j=1:10
    selected = 0;
    max_accu = 0;
    for i=1:length(features)
        %Check if this feature was not selected already
        if sum(i==selected_features)==0
            temp_features = [features_array X_train_master_pruned(:,i)];
            [accu] = glmfit_accu(temp_features, train_label');
            if accu>max_accu
                max_accu = accu;
                selected = i;
                
            end
        end
    end
    selected_features(end+1) = selected;
    features_array(:,end+1) = X_train_master_pruned(:, selected);
end

            