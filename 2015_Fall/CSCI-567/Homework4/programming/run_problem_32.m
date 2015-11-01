run_problem_31
C = power(4, [-6:2]);
rows = size(traindata,1);
permutations = randperm(rows);
permutedfeatures = traindata(permutations',:);
permutedlabels = trainlabels(permutations');
m = length((permutations));
s = floor(m/3);
f1 = permutedfeatures(1:s,:);
l1 = permutedlabels(1:s);
f2 = permutedfeatures(s+1:2*s,:);
l2 = permutedlabels(s+1:2*s);
f3 = permutedfeatures(2*s+1:m,:);
l3 = permutedlabels(2*s+1:m);

maxaccu = 0;
optimumC = 0;
time = 0;
tic;
for idx = 1:numel(C)
    c=C(idx);
    disp(sprintf('C: %f',c));
    tic;
    [w,b] = trainsvm([f1;f2], [l1;l2],c);
    disp(sprintf('Training Dataset 1: %s', toc() ));
    accu1 = testsvm(f3,l3,w,b);
    tic;
    [w,b] = trainsvm([f3;f2], [l3;l2],c);
    disp(sprintf('Training Dataset 2: %s', toc() ));
    accu2 = testsvm(f1,l1,w,b);
    tic;
    [w,b] = trainsvm([f1;f3], [l1;l3],c);
    disp(sprintf('Training Dataset 3: %s', toc() ));
    accu3 = testsvm(f2,l2,w,b);
    accu = (accu1+accu2+accu3)/3;
    if maxaccu<accu 
        maxaccu = accu;
        optimumC = c;
    end
end

%rate = sum(crossval(svmpredict,permutedlabels,permutedfeatures,'partition',c))...
 %          /sum(c.TestSize)

