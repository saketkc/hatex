clear all;
C = 4;
traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');

trainfeatures = double(traindata.features);
trainlabels = traindata.label';
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = testdata.label';
testfeatures = transformdata(testfeatures);



[w,b] = trainsvm(trainfeatures, trainlabels, C);
testaccu = testsvm(testfeatures, testlabels, w, b);
