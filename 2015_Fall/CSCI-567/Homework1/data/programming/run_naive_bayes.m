clear all;
disp('************ Problem 5.2(d) Naive Bayes Start*******************')
disp('Problem 5.2(d)')
[train_data, train_label] = preprocessing_ttt('hw1ttt_train.data');
[valid_data, valid_label] = preprocessing_ttt('hw1ttt_valid.data');
[test_data, test_label] = preprocessing_ttt('hw1ttt_test.data');

[test_accu, train_accu] = naive_bayes(train_data, train_label, test_data, test_label);
[valid_accu, train_accu] = naive_bayes(train_data, train_label, valid_data, valid_label);
disp('-------Tic Tac Toe Data:--------');
textstr=sprintf('Training Accuracy: %f\nValidation Accuracy: %f\nTesting Accuracy:%f\n', train_accu, valid_accu, test_accu);
disp(textstr)
[train_data, train_label] = preprocessing_nursery('hw1nursery_train.data');
[valid_data, valid_label] = preprocessing_nursery('hw1nursery_valid.data');
[test_data, test_label] = preprocessing_nursery('hw1nursery_test.data');


disp('-------Nursery Data:--------');
textstr=sprintf('Training Accuracy: %f\nValidation Accuracy: %f\nTesting Accuracy:%f\n', train_accu, valid_accu, test_accu);
disp(textstr)
[test_accu, train_accu] = naive_bayes(train_data, train_label, test_data, test_label);
[valid_accu, train_accu] = naive_bayes(train_data, train_label, valid_data, valid_label);

disp('************ Problem 5.2(d) Naive Bayes End*******************')
