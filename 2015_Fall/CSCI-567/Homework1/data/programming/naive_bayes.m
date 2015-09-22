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

averages = ones(length(alluniquelabels), size(train_data,2));
stddevs = ones(length(alluniquelabels), size(train_data,2));
test_label = [];

for j=1:length(alluniquelabels)        
    averages(j,:) = mean(train_data(train_label == alluniquelabels(j),:));
    stddevs(j,:) = std(train_data(train_label == alluniquelabels(j),:));
end
stddevs(stddevs(:,:) == 0) = 1;%;sqrt((train_data_size-1)/12);


for j=1:test_data_size
   for i=1:length(alluniquelabels)
       prior = priors(i);
       likelihood = pdf('normal',new_data(j,:),averages(i,:), stddevs(i,:));
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
       likelihood = pdf('normal',train_data(j,:),averages(i,:), stddevs(i,:));
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