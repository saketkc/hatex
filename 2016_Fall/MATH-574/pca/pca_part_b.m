clear all;
close all;
load('PCA_Exercise_Images.mat');
vectorized_images = [];
images = {};
images{1} = Photo_Images;
images{2} = VTEC_Images;
imgindex = 2;
img = images{imgindex}; 
title_img1 = 'First 25 eigen vector VTEC Images';
img_name1 = 'first25-VTEC-Images';
title_img2 = 'Last 25 eigen vector VTEC Images';
img_name2 = 'last25-VTEC-Images';
if (imgindex ==1)
    title_img1 = 'First 25 eigen vector Photo Images';
    img_name1 = 'first25-Photo-Images';
    title_img2 = 'Last 25 eigen vector Photo Images';
    img_name2 = 'last25-Photo-Images';
end
[nrow, ncol, nimg] = size(img);
for i=1:nimg
    vimg = vectorize_image(img(:,:,i));
    vectorized_images = [vectorized_images; vimg];
end
vectorized_images = double(vectorized_images);
[eigvals, eigvecs, projected, reconstructed] = perform_pca(vectorized_images, 25);

figure(1);
set(gca,'XTick',[]);
title(title_img1);
for i=1:25
    eigimage = reshape(eigvecs(:,i),20,20);
    subplot(5,5,i);
    colormap(gray);
    imagesc(eigimage);
    axis off;
    title(i);
end
%title(title_img1);
print(img_name1, '-dpng');
close all;
figure(1);
title(title_img2);
for i=1:25
    eigimage = reshape(eigvecs(:,375+i),20,20);
    subplot(5,5,i);
    colormap(gray);
    imagesc(eigimage);
    axis off;
    title(i);
end
print(img_name2, '-dpng');
close all;
