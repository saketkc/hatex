function [features, labels] = preprocessing_ttt(filename)
options = {'x','o','b'};
options_map = binary_mapper(options);
label = {'positive', 'negative'};
label_map = containers.Map(label, [1,2]);

data =  dataread('file', filename, '%s', 'delimiter', '\n');
size = length(data);
features = [];
labels = [];
for i=1:size
    splittext = strsplit(char(data(i)), ',');
    l_features = splittext(1:9);
    l_labels = splittext(10);
    mappedfeatures = [];
    for j=1:9        
        mappedfeatures = cat(2, mappedfeatures, options_map(char(l_features(j))));
    end
    features(end+1, 1:27) =  mappedfeatures;
    labels(end+1) = label_map(char(l_labels(1)));
end
