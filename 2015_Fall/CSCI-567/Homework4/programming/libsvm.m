traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);

optimc_rbf = 16;
optimg = 0.0625;

optimc_poly = 64;
optimdegree = 2;


opts = sprintf('-t 2 -c %f -g %f',optimc_rbf, optimg);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, rbf_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);

disp('*********RBF************');
disp(sprintf('Gamma: %f', optimg));
disp(sprintf('C: %f', optimc_rbf));
disp(sprintf('Accuracy: %f', rbf_accuracy(1)));
disp('*********RBF************');

opts = sprintf('-t 1 -c %f -d %f',optimc_poly, optimdegree);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, poly_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);
disp('*********Polynomial************');
disp(sprintf('Gamma: %f', optimc_poly));
disp(sprintf('Degree: %f', optimdegree));
disp(sprintf('Accuracy: %f', poly_accuracy(1)));
disp('*********Polynomial************');
