

region_size_01 = 64;
region_size_02 = region_size_01/2;

dp_true = 3;

c1 = spectral_energy_filter(region_size_01, region_size_01, dp_true);
c2 = spectral_energy_filter(region_size_02, region_size_02, dp_true);

[~, sy1, sx1] = fit_gaussian_2D(c1);
[~, sy2, sx2] = fit_gaussian_2D(c2);

dp1 = filter_std_dev_to_particle_diameter(sx1, region_size_01);
dp2 = filter_std_dev_to_particle_diameter(sx2, region_size_02);
