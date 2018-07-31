close all; % closes all figures

%% Setup
% read images and convert to floating point format
image1 = im2single(imread('makeup_after.jpg'));
image2 = im2single(imread('makeup_before.jpg'));


%% Filtering and Hybrid Image construction
cutoff_frequency = 5; 

filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);

low_frequencies = filter_image(image1,filter);

high_frequencies = image2 - filter_image(image2,filter);

% Combine the high frequencies and low frequencies

hybrid_image = low_frequencies + high_frequencies;

%% Visualize and save outputs
figure(1); imshow(low_frequencies)
figure(2); imshow(high_frequencies + 0.5);
vis = hybrid(hybrid_image);
figure(3); imshow(vis);
name = '_H_T';
imwrite(low_frequencies, ['low_frequencies' name '.jpg'], 'quality', 95);
imwrite(high_frequencies + 0.5, ['high_frequencies' name '.jpg'], 'quality', 95);
imwrite(hybrid_image, ['hybrid_image' name '.jpg'], 'quality', 95);
imwrite(vis, ['hybrid_image_scales' name '.jpg'], 'quality', 95);