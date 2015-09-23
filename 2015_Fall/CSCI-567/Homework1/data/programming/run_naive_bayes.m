clear all;
clc;
[train_data, train_label] = preprocessing_ttt('hw1ttt_train.data');
[valid_data, valid_label] = preprocessing_ttt('hw1ttt_valid.data');
[test_data, test_label] = preprocessing_ttt('hw1ttt_test.data');

[train_accu, test_accu] = naive_bayes(train_data, train_label, test_data, test_label)

[train_data, train_label] = preprocessing_nursery('hw1nursery_train.data');
[valid_data, valid_label] = preprocessing_nursery('hw1nursery_valid.data');
[test_data, test_label] = preprocessing_nursery('hw1nursery_test.data');


[train_accu, test_accu] = naive_bayes(train_data, train_label, test_data, test_label)

