
image_dir = '~/Desktop/frames';

% Images
image_list = dir(fullfile(image_dir, '*.tiff'));

% Number of images
num_images = length(image_list);

% Load the first image
