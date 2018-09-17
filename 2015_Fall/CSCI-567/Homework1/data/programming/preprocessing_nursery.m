function [features, labels] = preprocessing_nursery(filename)
parents = {'usual', 'pretentious', 'great_pret'} ;
has_nurs = {'proper', 'less_proper', 'improper', 'critical', 'very_crit'};
form = {'complete', 'completed', 'incomplete', 'foster'};
children = {'1', '2', '3', 'more'};
housing = {'convenient', 'less_conv', 'critical'};
finance = {'convenient', 'inconv'};
social = {'nonprob', 'slightly_prob', 'problematic'};
health = {'recommended', 'priority', 'not_recom'};

parents_map =  binary_mapper(parents);
nurs_map = binary_mapper(has_nurs);
form_map = binary_mapper(form);
children_map = binary_mapper(children);
housing_map = binary_mapper(housing);
finance_map = binary_mapper(finance);
social_map = binary_mapper(social);
health_map = binary_mapper(health);
label_map = containers.Map({'not_recom','recommend','very_recom','priority','spec_prior'},[1,2,3,4,5]);

mapped_list = containers.Map({1,2,3,4,5,6,7,8}, {parents_map, nurs_map, form_map, children_map, housing_map, finance_map, social_map, health_map});


data =  dataread('file', filename, '%s', 'delimiter', '\n');
size = length(data);
features = [];
labels = [];
for i=1:size
    splittext = strsplit(char(data(i)), ',');
    l_features = splittext(1:8);
    l_labels = splittext(9);
    mappedfeatures = [];
    for j=1:8
        mapper = (mapped_list(j));
        mappedfeatures = cat(2, mappedfeatures, mapper(char(l_features(j))));
    end
    features(end+1, 1:27) =  mappedfeatures;
    labels(end+1) = label_map(char(l_labels));
end
end
