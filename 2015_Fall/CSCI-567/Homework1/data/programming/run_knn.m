clear all;
clc;
[train_data, train_label] = preprocessing_ttt('hw1ttt_train.data');
[valid_data, valid_label] = preprocessing_ttt('hw1ttt_valid.data');
[test_data, test_label] = preprocessing_ttt('hw1ttt_test.data');
KKK = [1,3,5,7,9,11,13,15];
for i=1:length(KKK)
    t=KKK(i);
    [valid_accu, train_accu] = knn_classify(train_data, train_label, valid_data, valid_label, t);
    [test_accu, train_accu] = knn_classify(train_data, train_label, test_data, test_label, t);
    text = sprintf('%f & %f & %f & %f\n', t, train_accu, valid_accu, test_accu);
    disp(text);
end

    