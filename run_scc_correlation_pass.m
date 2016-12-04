function JOBFILE = run_scc_correlation_pass(JOBFILE, PASS_NUMBER)

% Default to pass number one
if nargin < 2
    PASS_NUMBER = 1; 
end

% Get the ensmeble length
% This will return 1 if 
% ensemble shouldn't be run.
ensemble_length = read_ensemble_length(JOBFILE, PASS_NUMBER);

% Correlation grid points
grid_correlate_x = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.X;
grid_correlate_y = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.Y;

% Full list of grid points
grid_full_x = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X;
grid_full_y = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.Y;

% Indices of grid points to correlate
grid_indices = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.Indices;

% Number of pairs to correlate
num_regions_correlate = length(grid_correlate_x(:));

% Total number of grid points
num_regions_full = length(grid_full_x(:));

% Number of pairs to correlate
num_pairs_correlate = read_num_pairs(JOBFILE, PASS_NUMBER);

% Region sizes
[region_height, region_width] = get_region_size(JOBFILE, PASS_NUMBER);

% Subpixel weights
sub_pixel_weights = ones(region_height, region_width);

% Estimated particle diameter
particle_diameter = JOBFILE.Processing(PASS_NUMBER).SubPixel.EstimatedParticleDiameter;

% Determine if deform is requested
iterative_method = JOBFILE.Processing(1).Iterative.Method;

% Determine whether deform is being performed
do_deform = ~isempty(regexpi(iterative_method, 'def'));

% Subpixel method
% % % For now ignore this and always do three-point fit.

% Allocate displacements (raw)
tx_raw_full = zeros(num_regions_full, 1);
ty_raw_full = zeros(num_regions_full, 1);

% Make the spatial windows
[spatial_window_01, spatial_window_02] = ...
    make_spatial_windows(JOBFILE, PASS_NUMBER);

% Ensemble domain string
ensemble_domain_string = lower(read_ensemble_domain(JOBFILE, PASS_NUMBER));

% Allocate correlation planes
switch lower(ensemble_domain_string)
    case 'spectral'
        
    % Allocate complex array for correlations
    cross_corr_ensemble = zeros(...
        region_height, region_width, num_regions_correlate) + ...
        1i * zeros(region_height, region_width, num_regions_correlate);
    
    % Allocate purely real array for correlations
    case 'spatial'
        cross_corr_ensemble = zeros(...
            region_height, region_width, num_regions_correlate);
end

% Loop over all the images
for n = 1 : num_pairs_correlate
    
    % Inform the user
    fprintf(1, 'On image pair %d of %d...\n', n, num_pairs_correlate);
    
    % Image paths
    image_path_01 = JOBFILE.Processing(PASS_NUMBER).Frames.Paths{1}{n};
    image_path_02 = JOBFILE.Processing(PASS_NUMBER).Frames.Paths{2}{n};
    
    % Load the images
    image_raw_01 = double(imread(image_path_01));
    image_raw_02 = double(imread(image_path_02));
    
    % If doing deformation, 
    % then execute deformation
    if do_deform
    
        % Read the deform parameters
        %
        % This is the grid from the previous pass, 
        % which will inform the deform method.
        deform_source_grid_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.X;
        deform_source_grid_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.Y;
        %
        % These are the displacements from the
        % previous pass, which will inform
        % the deform method.
        deform_source_displacement_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.X;
        deform_source_displacement_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.Y;

        % Deform method
        deform_interpolation_method = JOBFILE.Processing(1).Iterative.Deform.Interpolation;

        % Inform the user that
        % deform is happening.
        fprintf(1, 'Deforming images...\n');
        
        % Deform the images if requested.
        [image_01, image_02] = ...
            deform_image_pair(image_raw_01, image_raw_02, ...
            deform_source_grid_x, deform_source_grid_y, ...
            deform_source_displacement_x, deform_source_displacement_y, ...
            deform_interpolation_method);
        
    % If deform isn't specified,
    % then just use the raw images.
    else  
        image_01 = image_raw_01;
        image_02 = image_raw_02;

    end
    
    % Extract the regions
    region_mat_01 = extract_sub_regions(image_01, ...
        [region_height, region_width], ...
        grid_correlate_x, grid_correlate_y);
    region_mat_02 = extract_sub_regions(image_02, ...
        [region_height, region_width], ...
        grid_correlate_x, grid_correlate_y);
    
    % Loop over the regions
    for k = 1 : num_regions_correlate
        
        % Extract the subregions
        region_01 = region_mat_01(:, :, k);
        region_02 = region_mat_02(:, :, k);
       
        % Correlate the windows
        FT_01 = fft2(spatial_window_01 .* (region_01 - mean(region_01(:))));
        FT_02 = fft2(spatial_window_02 .* (region_02 - mean(region_02(:))));
        
        % Spectral correlation
        cross_corr_spectral = FT_01 .* conj(FT_02);
        
        % Spatial correlation
        cross_corr_spatial = fftshift(abs(ifft2(cross_corr_spectral)));
        
        % Add the spatial correlation to the ensemble
        cross_corr_ensemble(:, :, k) = cross_corr_ensemble(:, :, k) + ...
            cross_corr_spatial;   
    end   
end


% After adding all the pairs to the ensemble
% do the subpixel peak detection.

for k = 1 : num_regions_correlate
    
    % Extract the grid index
    grid_index = grid_indices(k);

    % Do the subpixel displacement estimate.
    [tx_raw_full(grid_index), ty_raw_full(grid_index)] = subpixel(cross_corr_ensemble(:, :, k),...
            region_width, region_height, sub_pixel_weights, ...
                1, 0, particle_diameter * [1, 1]);
                       
end

% Save the results to the structure
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.X(:, 1) = tx_raw_full;
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.Y(:, 1) = ty_raw_full;

% Do the validation if requested
do_validation = JOBFILE.Processing(PASS_NUMBER).Validation.DoValidation;

% Do validation if requested
if do_validation == true;
    
    % Inform the user
    fprintf(1, 'Performing validation...\n');
    
    % Calculate the validated field.
    [tx_val_full, ty_val_full, is_outlier_full] = ...
        validateField_prana(grid_full_x, grid_full_y, tx_raw_full, ty_raw_full);
    
    % Add validated vectors to the jobfile
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.X = tx_val_full;
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.Y = ty_val_full;
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.IsOutlier = is_outlier_full;
    
    % Temporary vector of displacements
    % which will be passed to smoothing if requested
    tx_temp_full = tx_val_full;
    ty_temp_full = ty_val_full;
   
else
    
    % If velidation wasn't requested, 
    % then set the temporary vector
    % field to be equal to
    % the raw vector field.
    % This will be passed to the smoother
    % (but only if smoothing is requested).
    tx_temp_full = tx_raw_full;
    ty_temp_full = ty_raw_full;
end

% Determine whether to do smoothing.
do_smoothing = JOBFILE.Processing(PASS_NUMBER).Smoothing.DoSmoothing;

% Smoothing
if do_smoothing == true
    
    % Inform the user
    fprintf(1, 'Performing smoothing...\n');
    
    % Extract the smoothing parameters
    smoothing_kernel_diameter = JOBFILE.Processing(PASS_NUMBER).Smoothing.KernelDiameter;
    smoothing_kernel_std = JOBFILE.Processing(PASS_NUMBER).Smoothing.KernelStdDev;

    % Calculate smoothed field
    tx_smoothed_full = smoothField(tx_temp_full, smoothing_kernel_diameter, smoothing_kernel_std);
    ty_smoothed_full = smoothField(ty_temp_full, smoothing_kernel_diameter, smoothing_kernel_std);
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.X = tx_smoothed_full;
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.Y = ty_smoothed_full;

end

% quiver(grid_full_x, grid_full_y, tx_smoothed_full, ty_smoothed_full, 3, 'black');
% axis image

end













