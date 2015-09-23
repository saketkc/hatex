clear all;
clc;
[train_data, train_label] = preprocessing_ttt('hw1ttt_train.data');
[valid_data, valid_label] = preprocessing_ttt('hw1ttt_valid.data');
[test_data, test_label] = preprocessing_ttt('hw1ttt_test.data');

for ml=1:10
    [accu_train_gdi, accu_train_dev, accu_valid_gdi, accu_valid_dev] = decision_tree(train_data, train_label, valid_data, valid_label, ml);
    [accu_train_gdi, accu_train_dev, accu_test_gdi, accu_test_dev] = decision_tree(train_data, train_label, test_data, test_label, ml);

    text = sprintf('%f & %f & %f & %f & %f & %f \n',ml, accu_train_gdi, accu_train_dev, accu_valid_gdi, accu_valid_dev, accu_test_gdi, accu_test_dev);
    disp(text);
end

