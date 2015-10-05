%clear all;
%run_problem_4_a;
[pclass_bins, pclass_hist] = problem_4_b_hist(pclass_train, survival_train);
subplot(2,3,1);
bar(pclass_bins, pclass_hist);
title('pclass');
xlabel('pclass');
ylabel('Probability');


[age_bins, age_hist] = problem_4_b_hist(age_train, survival_train);
subplot(2,3,2);
bar(age_bins,age_hist);
title('age');
xlabel('age');
ylabel('Probability');



[sibsp_bins, sibsp_hist] = problem_4_b_hist(sibsp_train, survival_train);
subplot(2,3,3);
bar(sibsp_bins,sibsp_hist);
title('sibsp');
xlabel('sibsp');
ylabel('Probability');



[parch_bins, parch_hist] = problem_4_b_hist(parch_train, survival_train);
subplot(2,3,4);
bar(parch_bins, parch_hist);
title('parch');
xlabel('parch');
ylabel('Probability');



[fare_bins, fare_hist] = problem_4_b_hist(fare_train, survival_train);
subplot(2,3,5);
bar(fare_bins,fare_hist);
title('fare');
xlabel('fare');
ylabel('Probability');
print('problem4b', '-dpng')
disp('Nothing to output. Plt saved at problem4.png')


