load('PCA_Exercise_Images.mat')
vectorized_images = [];
[nrow, ncol, nimg] = size(Photo_Images);
for i=1:nimg
    vimg = vectorize_image(Photo_Images(:,:,i));
    vectorized_images = [vectorized_images; vimg];
end
vectorized_images = double(vectorized_images);
[eigvals, eigvecs, projected, reconstructed] = perform_pca(vectorized_images, 25);

set(gca,'XTick',[]);
for i=1:25
    eigimage = reshape(eigvecs(:,i),20,20);
    subplot(5,5,i);
    colormap(gray);
    imagesc(eigimage);
    axis off;
    title(i); 
end
print('top25', '-dpng');
close all;
for i=1:25
    eigimage = reshape(eigvecs(:,375+i),20,20);
    subplot(5,5,i);
    colormap(gray);
    imagesc(eigimage);
    axis off;
    title(i); 
end
print('bottom25', '-dpng');
close all;
