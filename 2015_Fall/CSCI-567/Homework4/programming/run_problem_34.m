C = power(4,[-6:2]);
traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);
for idx=1:numel(C)
    c = C(idx);
    disp(sprintf('C: %f',c));
    tic;
    model = svmtrain(trainlabels, trainfeatures, '-v 3 -c ' + c);
    disp(sprintf('Time: %f', toc() ));
    [predicted_label, accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);
end
