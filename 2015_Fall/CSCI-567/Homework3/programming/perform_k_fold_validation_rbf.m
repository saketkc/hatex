function [err, W] = perform_k_fold_validation_rbf(sigma, lambda, input_data)
    k = 5;
    cols = size(input_data,2);
    datasize = size(input_data,1);
    permuted = randperm(datasize);
    binsize = floor(datasize/k);
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
        [W] = kernel_rbf(sigma, lambda,training_data(:,2:cols), training_data(:,1));
        [helderror] = kernel_linear_estimate_error(W, test_data(:,2:cols), test_data(:,1));
        err = err+helderror;
    end
    err = err/k;
end
