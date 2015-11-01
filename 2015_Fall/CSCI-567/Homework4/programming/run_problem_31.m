clear all;
data = load('phishing-train.mat');
trainfeatures = double(data.features);
trainlabels = double(data.label');

traindata = transformdata(trainfeatures);


