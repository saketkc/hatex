function [standardise_new_data, mean_input_data, std_input_data] = normalise(input_data)
mean_input_data = mean(input_data);
std_input_data = std(input_data);

standardise_new_data = bsxfun(@minus, input_data, mean_input_data );
standardise_new_data = bsxfun(@rdivide, standardise_new_data, std_input_data);
end

