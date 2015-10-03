clear all;
run_problem_4_a;
disp('--------------Problem 4c-----------------');
[pclass_category_hist, pclass_category, pclass_division_boundaries] = problem_4_c_discretizer( pclass_train );
[hy, pclass_hx] = problem_4_c_entropy_calculator_corrected(pclass_category, survival_train);

disp(sprintf('pclass: %f',hy-pclass_hx));

[category_hist, category, division_boundaries] = problem_4_c_discretizer( age_train );
[hy, age_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('age: %f',hy-age_hx));

[category_hist, category, division_boundaries] = problem_4_c_discretizer( sibsp_train );
[hy, sibsp_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('sibsp: %f',hy-sibsp_hx));

[category_hist, category, division_boundaries] = problem_4_c_discretizer( parch_train );
[hy, parch_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('parch: %f', hy-parch_hx));

[category_hist, category, division_boundaries] = problem_4_c_discretizer( fare_train );
[hy, fare_hx] = problem_4_c_entropy_calculator_corrected(category, survival_train);
disp(sprintf('fare: %f',hy-fare_hx));




[hy, embarked_hx] = problem_4_c_entropy_calculator_corrected(embarked_train, survival_train);
disp(sprintf('embarked: %f',hy-embarked_hx));


%[hy, ticket_hx] = problem_4_c_entropy_calculator(ticket_train, survival_train);
%disp(sprintf('ticket: %f',hy-ticket_hx));

%{
pclass          Passenger Class
                (1 = 1st; 2 = 2nd; 3 = 3rd)
survival        Survival
                (0 = No; 1 = Yes)
name            Name
sex             Sex

age             Age
sibsp           Number of Siblings/Spouses Aboard
parch           Number of Parents/Children Aboard

ticket          Ticket Number
fare            Passenger Fare
cabin           Cabin
embarked        Port of Embarkation
                (C = Cherbourg; Q = Queenstown; S = Southampton)

boat            Lifeboat
body            Body Identification Number
home.dest       Home/Destination
%}

[hy, boat_hx] = problem_4_c_entropy_calculator(boat_train, survival_train);
disp(sprintf('boat: %f',hy-boat_hx));

[hy, body_hx] = problem_4_c_entropy_calculator(body_train, survival_train);
disp(sprintf('body: %f',hy-body_hx));


[hy, sex_hx] = problem_4_c_entropy_calculator_corrected(sex_train, survival_train);
disp(sprintf('sex: %f',hy-sex_hx));




