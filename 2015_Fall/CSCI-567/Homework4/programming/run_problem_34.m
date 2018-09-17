C = power(4,[-6:2]);
rng(1)
traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);
maxaccu=0;
optimC = 0;
for idx=1:numel(C)
    c = C(idx);
    disp(sprintf('C: %f',c));
    opts = sprintf('-v 3 -c %f -q', c);
    tic;
    model = svmtrain(trainlabels, trainfeatures, opts);
    disp(sprintf('Training Time: %f', toc() ));
    if maxaccu<model(1)
        maxaccu = model(1);
        optimumC = c;
    end
end
disp(sprintf('Optimum C: %f', optimumC));
opts = sprintf('-c %f -q', optimumC);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, accuracy, decision_values] = svmpredict(testlabels, testfeatures, model, '-q');
disp(sprintf('Testing Accuracy: %f', accuracy(1)));
