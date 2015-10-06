%clear all;
%run_problem_4_a;
disp('--------------Non sorted Muttual Information-----------------');

keys = {'pclass', 'age','sibsp','parch','fare','embarked','ticket','boat','body', 'sex', 'name', 'cabin', 'home'};
values = [];
[pclass_category_hist, pclass_category, pclass_division_boundaries] = problem_4_c_discretizer( pclass_train );
[hy, pclass_hx] = problem_4_c_entropy_calculator_corrected(pclass_category, survival_train);
disp(sprintf('pclass: %f',hy-pclass_hx))
values(end+1) = hy-pclass_hx;


[category_hist, category, division_boundaries] = problem_4_c_discretizer( age_train );
[hy, age_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('age: %f',hy-age_hx));
values(end+1) = hy-age_hx;

[category_hist, category, division_boundaries] = problem_4_c_discretizer( sibsp_train );
[hy, sibsp_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('sibsp: %f',hy-sibsp_hx));
values(end+1) = hy-age_hx;

[category_hist, category, division_boundaries] = problem_4_c_discretizer( parch_train );
[hy, parch_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('parch: %f', hy-parch_hx));
values(end+1) = hy-parch_hx;


[category_hist, category, division_boundaries] = problem_4_c_discretizer( fare_train );
[hy, fare_hx] = problem_4_c_entropy_calculator_corrected(fare_train, survival_train);
disp(sprintf('fare: %f',hy-fare_hx));
values(end+1) = hy-parch_hx;


[hy, embarked_hx] = problem_4_c_entropy_calculator_corrected(embarked_train, survival_train);
disp(sprintf('embarked: %f',hy-embarked_hx));
values(end+1) = hy-embarked_hx;

[hy, ticket_hx] = problem_4_c_entropy_calculator_corrected(ticket_train, survival_train);
disp(sprintf('ticket: %f',hy-ticket_hx));
values(end+1) = hy-ticket_hx;

[hy, boat_hx] = problem_4_c_entropy_calculator_corrected(boat_train, survival_train);
disp(sprintf('boat: %f',hy-boat_hx));
values(end+1) = hy-boat_hx;

[hy, body_hx] = problem_4_c_entropy_calculator_corrected(body_train, survival_train);
disp(sprintf('body: %f',hy-body_hx));
values(end+1) = hy-body_hx;

[hy, sex_hx] = problem_4_c_entropy_calculator_corrected(sex_train, survival_train);
disp(sprintf('sex: %f',hy-sex_hx));
values(end+1) = hy-sex_hx;

[hy, name_hx] = problem_4_c_entropy_calculator_corrected(name_train, survival_train);
disp(sprintf('name: %f',hy-name_hx));
values(end+1) = hy-name_hx;

[hy, cabin_hx] = problem_4_c_entropy_calculator_corrected(cabin_train, survival_train);
disp(sprintf('cabin: %f',hy-cabin_hx));
values(end+1) = hy-cabin_hx;

[hy, home_hx] = problem_4_c_entropy_calculator_corrected(home_train, survival_train);
values(end+1) = hy-home_hx;
disp(sprintf('home: %f',hy-home_hx));

[s,I] = sort(values, 'descend');

disp('--------------Sorted Mutual Information-----------------');
for i=1:length(I)
    x = I(i);
    disp(sprintf('%s: %f',keys{x}, values(x)));
end
