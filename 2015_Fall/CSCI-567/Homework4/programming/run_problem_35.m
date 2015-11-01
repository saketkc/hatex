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
optimc_poly = 0;
optimg = 0;


for idx=1:numel(C)
    c = C(idx);
    disp(c);
    for dx=1:numel(degree)
        d = degree(dx);
        opts = sprintf('-v 3 -t 1 -c %f -d %f',c,d);
        model = svmtrain(trainlabels, trainfeatures, opts);
        accuracy = (model(1));
        if maxaccu<accuracy
            maxaccu = accuracy;
            optimc_poly = c;
            optimdegree = dx;
        end
    end
end

opts = sprintf('-t 1 -c %f -d %f',optimc_poly, optimdegree);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, poly_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);

maxaccu = 0;
optimg = 0;
optimc_rbf = 0;



for idx=1:numel(C)
    c = C(idx);
    disp(c);
    for dx=1:numel(gamma)
        g = gamma(dx);
        opts = sprintf('-v 3 -t 2 -c %f -g %f',c,g);
        model = svmtrain(trainlabels, trainfeatures, opts);
        accuracy = (model(1));
        if maxaccu<accuracy
            maxaccu = accuracy;
            optimg = g;
            optimc_rbf = c;
        end
    end
end

opts = sprintf('-t 2 -c %f -g %f',optimc_rbf, optimg);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, rbf_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);
