C = power(4,[-3:7]);
degree = [1,2,3];
gamma = power(4, [-7:-1] );
rng(1);

traindata  = load('phishing-train.mat');
testdata = load('phishing-test.mat');
trainfeatures = double(traindata.features);
trainlabels = double(traindata.label');
trainfeatures = transformdata(trainfeatures);

testfeatures = double(testdata.features);
testlabels = double(testdata.label');
testfeatures = transformdata(testfeatures);

poly_maxaccu = 0;
optimdegree = 0;
optimc_poly = 0;
optimg = 0;

disp('*******************************Polynomial****************************');
tocs = [];
accus = [];
for idx=1:numel(C)
    c = C(idx);
    disp(sprintf('C= %f',c));
    for dx=1:numel(degree)
        d = degree(dx);
        opts = sprintf('-v 3 -t 1 -c %f -d %f -q',c,d);
        tic;
        model = svmtrain(trainlabels, trainfeatures, opts);
        %disp(sprintf('Time: %f', toc() ));
        tocs(end+1) = toc();
        accuracy = (model(1));
        accus(end+1) = accuracy;
        %disp(sprintf(': %f', toc() ));
        if poly_maxaccu<accuracy
            poly_maxaccu = accuracy;
            optimc_poly = c;
            optimdegree = dx;
        end
    end
end

for idx=1:numel(C)
disp(sprintf('%f & %f & %f\\', C(idx), tocs(idx), accus(idx)));
disp('\hline');
end
accus = [];
tocs = [];
opts = sprintf('-t 1 -c %f -d %f -q',optimc_poly, optimdegree);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, poly_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model);

rbf_maxaccu = 0;
optimg = 0;
optimc_rbf = 0;

disp('*******************************RBF****************************');

for idx=1:numel(C)
    c = C(idx);
    for dx=1:numel(gamma)
        g = gamma(dx);
        disp(sprintf('C= %f',c));
        opts = sprintf('-v 3 -t 2 -c %f -g %f -q',c,g);
        tic;
        model = svmtrain(trainlabels, trainfeatures, opts);
        tocs(end+1) = toc();
        %disp(sprintf('Time: %f', toc() ));
        accuracy = (model(1));
        accus(end+1) = accuracy;
        if rbf_maxaccu<accuracy
            rbf_maxaccu = accuracy;
            optimg = g;
            optimc_rbf = c;
        end
    end
end

for idx=1:numel(C)
disp(sprintf('%f & %f & %f\\', C(idx), tocs(idx), accus(idx)));
disp('\hline');
end

opts = sprintf('-q -t 2 -c %f -g %f',optimc_rbf, optimg);
model = svmtrain(trainlabels, trainfeatures, opts);
[predicted_label, rbf_accuracy, decision_values] = svmpredict(testlabels, testfeatures, model, '-q');

disp(sprintf('Polynomal Kernel train accuracy: %f', poly_maxaccu));
disp(sprintf('RBF Kernel train accuracy: %f', rbf_maxaccu));

if (poly_maxaccu<rbf_maxaccu)
disp(sprintf('Better kernel: %s', 'RBF'))
else
disp(sprintf('Better kernel: %s', 'Polynomial'))
end

disp(sprintf('Polynomial Kernel optimal C: %f', optimc_poly));
disp(sprintf('Polynomial Kernel optimal degree: %f', optimdegree));
disp(sprintf('Polynomal Kernel test accuracy: %f', poly_accuracy(1)));
disp(sprintf('RBF Kernel optimal g: %f', optimg))
disp(sprintf('RBF Kernel optimal c: %f', optimc_rbf))
disp(sprintf('RBF Kernel test accuracy: %f', rbf_accuracy(1)));

