% % % 
% This script is for playing around with the 
% phase-quality based APC filter code.


region_width = 128;
region_height = 128;
sx = 3;
sy = 3;
noise_std = 0.5;

% Particle size used to generate 
% the actual decay of the correlation
particle_diameter = 4;

% Radius of the kernel for
% calculating phase quality,
% which is in turn used to
% calculate the APC filter.
kernel_radius = 2;

xv = (1 : region_width) - fourier_zero(region_width);
yv = (1 : region_height) - fourier_zero(region_height);

[x, y] = meshgrid(xv, yv);

% Correlation envelope
corr_env = spectral_energy_filter(region_height, region_width, ...
    particle_diameter);

% Complex correlation
spc_complex = corr_env .* exp(-1i * 2 * pi * (sx * x / region_width + sy * y / region_height));

subplot(1, 2, 1);
imagesc(corr_env);
axis image;


% Noise array
noise_array = noise_std * randn(region_height, region_width) + ...
    1i * noise_std * randn(region_height, region_width);

% Noise correlation
spc_complex_noisy = spc_complex +  noise_array;

% Calculate the APC filter
[apc_filter, apc_std_y, apc_std_x, phase_quality, phase_angle] = ...
    calculate_apc_filter_phase_method(spc_complex_noisy, ...
    0 , kernel_radius);

subplot(2, 2, 1);
imagesc(angle(spc_complex_noisy)); 
axis image;

subplot(2, 2, 2);
imagesc(-1 * phase_quality);
axis image;
 
subplot(2, 2, 3);
imagesc(corr_env);
axis image;

subplot(2, 2, 4);
imagesc(apc_filter);
axis image;
