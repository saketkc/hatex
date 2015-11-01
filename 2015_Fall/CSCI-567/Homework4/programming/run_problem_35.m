C = power(4,[-3:7]);
degree = [1,2,3];
gamma = power(4, [-7:-1] );

traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);
maxaccu = 0;
optimdegree = 0;
optimc = 0;
for idx=1:numel(C)
    c = C(idx);
    disp(c);
    for dx=1:numel(degree)
        d = degree(dx);
        opts = sprintf('-v 3 -t 1 -c %f -d %f',c,d);
        model = svmtrain(trainlabels, trainfeatures, opts);
        [predicted_label, accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);
        if maxaccu<accuracy
            maxaccu = accuracy;
            optimc = c;
            optimdegree = dx;
        end
    end
end
