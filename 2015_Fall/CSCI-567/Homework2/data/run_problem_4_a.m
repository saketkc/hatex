fid = fopen('titanic3.tsv');
out = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 'delimiter','\t');
fclose(fid);
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
pclass_m = out{1};
assert(strcmp(pclass_m{1}, 'pclass'));
[pclass, pclass_missing] = problem_4_a_massager('str', pclass_m);
text= sprintf('pclass Missing: %d',pclass_missing);
disp(text);

survival_m = out{2};       
assert(strcmp(survival_m{1}, 'survived'));
[survival, survival_missing] = problem_4_a_massager('str', survival_m);
text= sprintf('survived Missing: %d',survival_missing);
disp(text);

name_m = out{3};
assert(strcmp(name_m{1}, 'name'));
[name, name_missing] = problem_4_a_massager('str', name_m);
text= sprintf('name Missing: %d',name_missing);
disp(text);

sex_m = out{4};
assert(strcmp(sex_m{1}, 'sex'));
[sex, sex_missing] = problem_4_a_massager('str', sex_m);
text= sprintf('sex Missing: %d', sex_missing);
disp(text);

age_m = out{5};
assert(strcmp(age_m{1}, 'age'));
[age, age_missing] = problem_4_a_massager('num', age_m);
text= sprintf('age Missing: %d',age_missing);
disp(text);

sibsp_m = out{6};
assert(strcmp(sibsp_m{1}, 'sibsp'));
[sibsp, sibsp_missing] = problem_4_a_massager('num', sibsp_m);
text= sprintf('sibsp Missing: %d', sibsp_missing);
disp(text);

parch_m = out{7};
assert(strcmp(parch_m{1}, 'parch'));
[parch, parch_missing] = problem_4_a_massager('num', parch_m);
text= sprintf('parch Missing: %d', parch_missing);
disp(text);

ticket_m = out{8};
assert(strcmp(ticket_m{1}, 'ticket'));
[ticket, ticket_missing] = problem_4_a_massager('str', ticket_m);
text= sprintf('ticket Missing: %d', ticket_missing);
disp(text);

fare_m = out{9};
assert(strcmp(fare_m{1}, 'fare'));
[fare, fare_missing] = problem_4_a_massager('num', fare_m);
text= sprintf('fare Missing: %d',fare_missing);
disp(text);

cabin_m = out{10};
assert(strcmp(cabin_m{1}, 'cabin'));
[cabin, cabin_missing] = problem_4_a_massager('str', cabin_m);
text= sprintf('cabin Missing: %d', cabin_missing);
disp(text);

embarked_m = out{11};
assert(strcmp(embarked_m{1}, 'embarked'));
[embarked, embarked_missing] = problem_4_a_massager('str', embarked_m);
text= sprintf('embarked Missing: %d',embarked_missing);
disp(text);


boat_m = out{12};
assert(strcmp(boat_m{1}, 'boat'));
[boat, boat_missing] = problem_4_a_massager('str', boat_m);
text= sprintf('boat Missing: %d', boat_missing);
disp(text);

body_m = out{13};
assert(strcmp(body_m{1}, 'body'));
[body, body_missing] = problem_4_a_massager('num', body_m);
text= sprintf('body Missing: %d', body_missing);
disp(text);

home_m = out{14};
assert(strcmp(home_m{1}, 'home.dest'));
[home, home_missing] = problem_4_a_massager('str', home_m);
text= sprintf('home Missing: %d', home_missing);
disp(text);

rand('seed',1);
ix = randperm(length(pclass));
train_ix = ix(1:floor(length(ix)/2));
test_ix = ix(ceil(length(ix)/2):length(ix));

train_label = cell2mat(survival(train_ix));
test_label = cell2mat(survival(test_ix));
survival_train = cell2mat(survival(train_ix));
survival_test = cell2mat(survival(test_ix));


pclass_train = cell2mat(pclass(train_ix));
pclass_test = cell2mat(pclass(test_ix));


name_train = name(train_ix);
name_test = name(test_ix);

age_train = age(train_ix);
age_test = age(test_ix);

sex_train = sex(train_ix);
sex_test = sex(test_ix);

sibsp_train = sibsp(train_ix);
sibsp_test = sibsp(test_ix);

parch_train = parch(train_ix);
parch_test = parch(test_ix);

ticket_train = ticket(train_ix);
ticket_test = ticket(test_ix);

fare_train = fare(train_ix);
fare_test = fare(test_ix);

cabin_train = cabin(train_ix);
cabin_test = cabin(test_ix);

embarked_train = embarked(train_ix);
embarked_test = embarked(test_ix);

boat_train = boat(train_ix);
boat_test = boat(test_ix);

body_train = body(train_ix);
body_test = body(test_ix);

home_train = home(train_ix);
home_test = home(test_ix);