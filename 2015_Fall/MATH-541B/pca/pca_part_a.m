load('PCA_Exercise_Images.mat')
vectorized_images = [];
[nrow, ncol, nimg] = size(Photo_Images);
for i=1:nimg
    vimg = vectorize_image(Photo_Images(:,:,i));
    vectorized_images = [vectorized_images; vimg];
end
mean_patch = reshape(mean(vectorized_images), 20,20);
imagesc(mean_patch)

