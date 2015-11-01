clear all;
data = load('phishing-train.mat');
trainfeatures = double(data.features);
trainlabels = data.label';

preprocessdata = transformdata(trainfeatures);


