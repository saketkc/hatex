function [ bin_no, prob ] = problem_4_b_hist( array, survival_train)
    bin_no = [];
    prob = [];
    array_unique = unique(array);
   
    for i=1:min(numel(array_unique), 10)
        if numel(array_unique)>=10
            range = max(array)-min(array);
            binsize = range/10;    
            bin_low = min(array) + (i-1)*binsize;
            bin_high = min(array) + (i)*binsize;
            indices = find(array>=bin_low & array<bin_high);
        else
            bin = array_unique(i);
            indices = find(array == bin);
        end
        survival_indices = survival_train(indices);
        prob(i) = length(survival_indices(survival_indices == '1'))/length(survival_train);        
        bin_no(i)= i;        
    end

end
