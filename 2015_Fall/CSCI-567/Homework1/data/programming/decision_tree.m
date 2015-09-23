function [accu_train_gdi, accu_train_dev, accu_new_gdi, accu_new_dev] = decision_tree(train_data, train_label, new_data, new_label, ml)
train_data_size = length(train_label);
new_data_size = length(new_label);

tree_gdi = ClassificationTree.fit(train_data,train_label, 'MinLeaf', ml, 'SplitCriterion', 'gdi', 'Prune', 'off');
tree_dev = ClassificationTree.fit(train_data, train_label, 'MinLeaf', ml, 'SplitCriterion', 'deviance', 'Prune', 'off');

pred_train_gdi = tree_gdi.predict(train_data);
pred_train_dev = tree_dev.predict(train_data);


pred_new_gdi = tree_gdi.predict(new_data);
pred_new_dev = tree_dev.predict(new_data);

accu_train_gdi = sum(pred_train_gdi' == train_label)/train_data_size;
accu_train_dev = sum(pred_train_dev' == train_label)/train_data_size;

accu_new_gdi = sum(pred_new_gdi' == new_label)/new_data_size;
accu_new_dev = sum(pred_new_dev' == new_label)/new_data_size;

end
