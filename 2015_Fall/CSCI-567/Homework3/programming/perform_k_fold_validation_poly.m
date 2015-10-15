function [err, W] = perform_k_fold_validation_poly(lambda, a,b, input_data)
    k = 5;
    cols = size(input_data,2);
    datasize = size(input_data,1);
    permuted = randperm(datasize);
    binsize = ceil(datasize/k);
    training_dataset_indices = [];
    err = 0;
    for i=1:k
        training_dataset_indices(end+1,:) = permuted(binsize*(i-1)+1:binsize*(i));
    end
    for index=1:k
        training_data  = [];
        for j=1:k
            if (j~=index) 
                z = (input_data(training_dataset_indices(j,:),:));
                training_data = [training_data; z];
            end
        end
        test_data = input_data(training_dataset_indices(index,:),:);
        [ypred] = kernel_poly(lambda,a,b,training_data(:,2:cols), training_data(:,1));
        [ypredtest] = kernel_poly_predict(lambda, a,b,training_data(:,2:cols), training_data(:,1), test_data(:,2:cols));%, training_data(:,1));
        [yerror] = kernel_poly_estimate_error(ypredtest, test_data(:,1));
        err = err+yerror;
    end
    err = err/k;
end
