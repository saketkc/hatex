load('PCA_Exercise_Images.mat')
vectorized_images = [];
[nrow, ncol, nimg] = size(Photo_Images);
original = double(Photo_Images(:,:,70));
r = 80;
for i=1:30
    for j=1:30
        patch = original(20*(i-1)+1:20*(i), 20*(j-1)+1:20*j);
        vimg = double(vectorize_image(patch));
        vectorized_images = [vectorized_images; vimg];
    end
end
[eigvals, eigvecs, projected, reconstructed] = perform_pca(vectorized_images, r);

%imagesc(original);
%print('pca-part-c-original', '-dpng');
%close all;

rec_patches_all = [];
rec_patches_temp = [];
for i=1:900
    rec_patch = reshape(reconstructed(i, :),20,20);
    rec_patches_temp = [rec_patches_temp  rec_patch];
    if (mod(i,30)==0)
        %rest
        rec_patches_all= [rec_patches_all;rec_patches_temp];
        rec_patches_temp = [];

    end
end
%imagesc(reshape(reconstructed,600,600));
imagesc(rec_patches_all);
print(sprintf('pca-part-c-reconstructed-r=%d',r), '-dpng');
close all;
