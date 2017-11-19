file_path = '/Users/matthewgiarra/Desktop/piv_test_images/piv_challenge/2014/A/vect_2017-11-17/apc/cropped/A_raw_apc_ensemble_rpcd_3_with_min_cropped_00001_00600.mat';

ind = 28;

load(file_path);

% Read the plane from the first pass
cc1 = JobFile.Processing(1).Correlation.Planes(:, :, ind);
cc1_norm = abs(cc1) ./ max(abs(cc1(:)));

% Read the plane from the final pass
cc2 = JobFile.Processing(end).Correlation.Planes(:, :, ind);
cc2_norm = abs(cc2) ./ max(abs(cc2(:)));



% Calculate the filter standard deviations
% in the Fourier domain
[f1, stdy1, stdx1] = calculate_apc_filter(cc1, 3, 'magnitude');
[f2, stdy2, stdx2] = calculate_apc_filter(cc2, 3, 'magnitude');




subtightplot(1, 2, 1);
surf(cc1_norm);
axis square;

subtightplot(1, 2, 2);
surf(cc2_norm);
axis square