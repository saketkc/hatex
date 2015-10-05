warning('off','all');

selected_features = [];
features = 1:size(X_train_master_pruned_normalised,2);
features_array = [];
training_accuracy_tracker = [];
test_accuracy_tracker = [];
test_label = [];
for j=1:length(survival_train)
    train_label(j) = str2num(survival_train(j));
end
for j=1:length(survival_test)
    test_label(j) = str2num(survival_test(j));
end

for j=1:10
    selected = 0;
    max_accu = 0;
    for i=1:length(features)
        %Check if this feature was not selected already
        if sum(i==selected_features)==0
            temp_features = [features_array X_train_master_pruned_normalised(:,i)];
            [accu] = glmfit_accu(temp_features, train_label');
            if accu>max_accu
                max_accu = accu;
                selected = i;                
            end
        end
    end
    training_accuracy_tracker(end+1) = max_accu;
    selected_features(end+1) = selected;    
    test_accu = glmfit_accu(X_test_master_pruned_normalised(:,selected_features), test_label'); 
    test_accuracy_tracker(end+1) = test_accu;
    features_array(:,end+1) = X_train_master_pruned_normalised(:, selected);
    disp(sprintf('Iteration: %d \t Train Accuracy: %f \t Test Accuracy: %f', j, max_accu, test_accu));
end

plot(1:10, test_accuracy_tracker, '-r', 1:10, training_accuracy_tracker, '-g');
title('Training/Test accuracy v/s iteration number');
xlabel('Iteration');
ylabel('Accuracy');
legend('Testing accuracy', 'Training_accuracy');
print('accuracy.png', '-dpng')

            
