traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);

optimc_rbf = 16.0;
optimg = 0.0625;

opts = sprintf('-t 2 -c %f -g %f -q',optimc_rbf, optimg);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, rbf_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);

disp('*********Best Kernel = RBF*******')
disp('*********RBF************');
disp(sprintf('Gamma: %f', optimg));
disp(sprintf('C: %f', optimc_rbf));
disp(sprintf('Test Accuracy: %f', rbf_accuracy(1)));
disp('*********RBF************');

