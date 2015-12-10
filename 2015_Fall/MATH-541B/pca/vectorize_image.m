function [vectorized_image] = vectorize_image(image)
%fun = @(block_struct) imresize(block_struct.data,[1 400]);
im = double(image);
%vectorized_image = blockproc(im, [20 20], fun);
vectorized_image = im2col(image, [20 20], 'distinct')';
end
