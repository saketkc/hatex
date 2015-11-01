function [testaccu] = testsvm(testdata,testlabels, w,b)
rows = size(testdata,1);
cols = size(testdata,2);
t1 = [testdata ones(rows,1)];
predictedlabel = sign(double([testdata ones(rows,1)]) * [w;b]);
testlabels = sign(testlabels);
testaccu = sum(predictedlabel==testlabels)/rows;
end
