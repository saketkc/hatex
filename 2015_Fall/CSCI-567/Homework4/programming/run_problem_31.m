clear all;
data = load('phishing-train.mat');
trainfeatures = double(data.features);
trainlabels = data.label';

traindata = transformdata(trainfeatures);


