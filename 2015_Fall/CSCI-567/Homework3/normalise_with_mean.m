function [standardise_new_data] = normalise_with_mean(input_data, mean_input_data, std_input_data)

standardise_new_data = bsxfun(@minus, input_data, mean_input_data );
standardise_new_data = bsxfun(@rdivide, standardise_new_data, std_input_data);
end

