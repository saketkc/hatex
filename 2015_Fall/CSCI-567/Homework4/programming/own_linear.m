clear all;
C = 16;
traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');

trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);



[w,b] = trainsvm(trainfeatures, trainlabels, C);
testaccu = testsvm(testfeatures, testlabels, w, b);
disp(sprintf('Own linear test accuracy: %f', testaccu))
