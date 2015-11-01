function [w,b] = trainsvm(trainfeatures,trainlabels,C)

[rows,cols] = size(trainfeatures);
trainfeatures = double(trainfeatures);
trainlabels = double(trainlabels);
%(w b eps)
%(cols 1 rows)

h = [ones(cols,1); zeros(rows+1,1)];
H = diag(h);
f = [zeros(cols+1,1); ones(rows,1)];
f = C.*f;
a1 = diag(trainlabels);
a2 = [trainfeatures ones(rows,1)];% eye(rows)];
Ain = double(a1)*double(a2);i
Ain = -[Ain eye(rows)];
bin = -ones(rows,1);
lowerb = [-inf(cols+1,1); zeros(rows,1)];
[x] = quadprog(H,f,Ain,bin,[],[],lowerb, [], [], optimoptions('quadprog', 'Algorithm', 'interior-point-convex'));
w = x(1:cols);
b = x(cols+1);
end

