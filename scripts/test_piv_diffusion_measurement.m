% function test_piv_diffusion_measurement()

% Image size
image_height = 1024;
image_width = 1024;

% Region size
region_height = 64;
region_width = 64;

% Window fraction
window_fraction = 0.5 * [1, 1];

% Shuffle range
shuffle_range = [image_height/2 - region_height/2,...
    image_width/2 - region_width/2];

% Shuffle step
shuffle_step = [region_height/2, region_width/2];

% Diffusions
% dx_rand_list = [sqrt(2), 2 * sqrt(2)];
dx_rand_list = [1.0, 2, 3];

% Number of pairs
num_pairs = 1;

% Image repo
img_repo = '~/Desktop/piv_test_images';

% Image size
image_size = [image_height, image_width];

% Region size
region_size = [region_height, region_width];

% Make the images
[image_paths_01, image_paths_02] = make_diffusion_images(...
    dx_rand_list, num_pairs, image_size, img_repo);

% Single grid point!
grid_x = image_width/2;
grid_y = image_height/2;

% Number of regions
num_regions = length(grid_x(:));

% Number of diffusions
num_diffusions = length(dx_rand_list(:));

% Alloates
ft_pdf_std_x = zeros(num_regions, num_diffusions);
ft_pdf_std_y = zeros(num_regions, num_diffusions);

dx_std = zeros(num_regions, num_diffusions);
dy_std = zeros(num_regions, num_diffusions);

% Array of coordinates
xv = 1 : region_width;
yv = 1 : region_height;
[x, y] = meshgrid(xv - fourier_zero(region_width), yv - fourier_zero(region_height));

% Allocate
sy = zeros(num_diffusions);
sx = zeros(num_diffusions);

% Loop over diffusion cases
for k = 1 : num_diffusions
   [~, ~, ft_pdf_std_y(:, k), ft_pdf_std_x(:, k), dy_std(:, k), dx_std(:, k)] = ...
    measure_piv_diffusion(image_paths_01(:, k), image_paths_02(:, k), ...
    grid_y, grid_x, region_size, window_fraction, shuffle_range, shuffle_step);

    % Measure the displacement PDF by taking the inverse FT of the best-fit
    % of the CC magnitude divided by the autocorrelation magnitude.
    G = exp(-x.^2 / (2 * ft_pdf_std_x(k)^2)) .* exp(-y.^2 / (2 * ft_pdf_std_y(k)^2));
    g = abs(fftshift(ifft2(fftshift(G))));
    [~, sy(k), sx(k)] = fit_gaussian_2D(g);

    fprintf(1, 'dx_std true = %0.4f, dx_std_meas = %0.4f\n', dx_rand_list(k), dx_std(k));
end




% end



