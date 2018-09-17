function [new_accu, train_accu] = naive_bayes(train_data, train_label, new_data, new_label)
train_data_size = size(train_data,1);
test_data_size = size(new_data,1);

uniquelabels = unique(train_label);
uniquetestlabels = unique(new_label);
alluniquelabels = union(uniquelabels, uniquetestlabels);
%priors = hist(train_label, alluniquelabels);
%priors = priors/sum(priors); %It should be a probability

test_label = [];
p_x_giveny = [];
priors = [];

for j=1:length(alluniquelabels)        
    label = alluniquelabels(j);    
    labeldata = train_data(train_label == label,:);
    labelsize = size(labeldata,1);
    lf = sum(labeldata,1);
    p_x_giveny(end+1,:) = lf/labelsize;
    priors(end+1,:) = labelsize/train_data_size;
end
p_x_giveny(p_x_giveny(:,:) == 0) = 0.01;

for j=1:test_data_size
    posterior=[];
    test_vector = new_data(j,:);
   for i=1:length(alluniquelabels)
       prior = priors(i);
       likelihood = p_x_giveny(i,:); 
       posterior(i) = log(prior)+sum(log(likelihood).*test_vector);
   end
   [max_posterior, class_ind] = max(posterior);
   test_label(end+1) = alluniquelabels(class_ind);
end
new_accu =0;

new_accu = sum(test_label == new_label);

new_label=[];
test_label = [];

for j=1:train_data_size
    posterior = [];
    test_vector = train_data(j,:);
   for i=1:length(alluniquelabels)
       prior = priors(i);
       likelihood = p_x_giveny(i,:);
       posterior(i) = log(prior)+sum(log(likelihood).*test_vector);
   end
   [max_posterior, class_ind] = max(posterior);
   test_label(end+1) = alluniquelabels(class_ind);
end

train_accu = sum(test_label == train_label);
new_accu = new_accu/test_data_size;
train_accu = train_accu/train_data_size;

end