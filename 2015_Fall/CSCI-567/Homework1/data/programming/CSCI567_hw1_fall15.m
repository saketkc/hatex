function [] = CSCI567_hw1_fall15()
disp('****************** Problem 5.1(a) Start ******************');
run_problem_5_1_a
disp('****************** Problem 5.1(a) End ******************');

disp('****************** Problem 5.2(b) Start ******************');
disp('=========Running Naive Bayes=========')
run_naive_bayes
disp('****************** Problem 5.2(b) End ******************');

disp('****************** Problem 5.2(c) Start ******************');
disp('=========Running knn=========')
run_knn
disp('****************** Problem 5.2(c) End ******************');

disp('****************** Problem 5.2(d) Start ******************');
disp('=========Running Decision Tree=========')
run_decision_tree
disp('****************** Problem 5.2(d) End ******************');

disp('****************** Problem 5.2(d) Start ******************');
disp('=========Running knn decision boundary=========')
run_knn_decision_boundary
disp('****************** Problem 5.2(d) End ******************');
end

