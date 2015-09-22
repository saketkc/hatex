function [new_accu, train_accu] = naive_bayes(train_data, train_label, new_data, new_label)
train_data_size = size(train_data,1);
test_data_size = size(new_data,1);

uniquelabels = unique(train_label);
uniquetestlabels = unique(new_label);
alluniquelabels = union(uniquelabels, uniquetestlabels);
priors = hist(train_label, alluniquelabels);
priors = priors/sum(priors); %It should be a probability

% We use a gaussian kernel for estimating the likelihood,
% its parameters being the mean and standard deviation of that class.

test_label = [];
p_x_giveny = [];
for j=1:length(alluniquelabels)        
    label = alluniquelabels(j);
    indices = find(train_label == label)';
    labeldata = train_data(indices,:);
    labelsize = size(labeldata,1);
    lp = labelsize / train_data_size;
    lf = sum(labeldata);
    p_x_giveny(end+1,:) = lf/labelsize;
end
p_x_giveny(p_x_giveny(:,:) == 0) = 0.1;
p_x_giveny(p_x_giveny(:,:) >= 1) = 0.99;

for j=1:test_data_size
   for i=1:length(alluniquelabels)
       prior = priors(i);
       likelihood = p_x_giveny(i);  %pdf('normal',new_data(j,:),averages(i,:), stddevs(i,:));
       posterior(i) = prior*prod(likelihood);
   end
   [max_posterior, class_ind] = max(posterior);
   test_label(end+1) = alluniquelabels(class_ind);
end
new_accu =0;

for  i=1:test_data_size
    if new_label(i) == test_label(i);
        new_accu = new_accu+1;
    end
end
new_label=[];
for j=1:train_data_size
   for i=1:length(alluniquelabels)
       prior = priors(i);
       likelihood = p_x_giveny(i);
       posterior(i) = prior*prod(likelihood);
   end
   [max_posterior, class_ind] = max(posterior);
   test_label(end+1) = alluniquelabels(class_ind);
end

train_accu =0;
for  i=1:train_data_size
    if test_label(i) == train_label(i);
        train_accu = train_accu+1;
    end
end

new_accu = new_accu/test_data_size;
train_accu = train_accu/train_data_size;

end