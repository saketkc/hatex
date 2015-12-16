clear all;
close all;
load('PCA_Exercise_Images.mat')
vectorized_images = [];
images = {};
images{1} = Photo_Images;
images{2} = VTEC_Images;
imgindex = 1;
img = images{imgindex}; 
title_img = 'Mean Patch VTEC Images';
img_name = 'Mean-Patch-VTEC-Images';
if (imgindex ==1)
    title_img = 'Mean Patch Photo Images';
    img_name = 'Mean-Patch-Photo-Images';
end

[nrow, ncol, nimg] = size(img);
for i=1:nimg
    vimg = vectorize_image(img(:,:,i));
    vectorized_images = [vectorized_images; vimg];
end
mean_patch = reshape(mean(vectorized_images), 20,20);
width = 20;     % Width in inches
height = 20;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 21;      % Fontsize
lw = 2.5;      % LineWidth
msz = 19;       % MarkerSize

figure(2);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]);
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
imagesc(mean_patch);
title(title_img);
set(gca, 'XTick', []);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
print(img_name,'-dpng');
