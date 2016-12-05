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

% Determine whether deform is requested
deform_requested = ~isempty(regexpi(iterative_method, 'def'));

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

    % Before any deform action happens,
    % set the images to be processed 
    % (image_01 and image_02) to be equal
    % to the raw input images.
    % This is the "default" configuration.
    % If deform proceeds
    % then the data stored in
    % image_01 and image_02 (the raw images) will 
    % be replaced with the deformed images.
    image_01 = image_raw_01;
    image_02 = image_raw_02;

    % If doing deformation, 
    % then execute deformation
    if deform_requested
    
        % Read the deform parameters
        %
        % This is the grid from the previous pass, 
        % which will inform the deform method.
        source_grid_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.X;
        source_grid_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.Y;
        %
        % These are the displacements from the
        % previous pass, which will inform
        % the deform method.
        source_displacement_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.X;
        source_displacement_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.Y;

        % Deform method
        deform_interpolation_method = JOBFILE.Processing(1).Iterative.Deform.Interpolation;

        % Determine if the data present
        % would result in any deformation happening
        %
        % If all of the source displacements are zero,
        % then the images shouldn't be deformed, 
        % even if deformation is requested.
        % I (Matt Giarra) wrote the deform code
        % to check internally check for this condition
        % and to skip deformation if all the source
        % displacements are zero. Because of that,
        % this if-else block (the one you're reading right now)
        % is kind of redundant.
        % The reason I've put it here anyway
        % is to make the code more understandable:
        % I don't want it to look like deform is
        % always run no matter what. Without this block
        % that's how the code would read (I think), and you'd have
        % to go into the deform code itself to realize that 
        % zero-everywhere displacement fields result
        % in the image deformation getting skipped.
        deform_data_exist = or(any(source_displacement_x ~= 0), ...
            any(source_displacement_y ~= 0));

        % Determine whether to do deform
        deform_can_proceed = and(deform_requested, deform_data_exist);

        % Do the deform if conditions are satisfied
        if deform_can_proceed
            % Inform the user that
            % deform is happening.
            fprintf(1, 'Deforming images...\n');

            % Deform the images if requested.
            [image_01, image_02] = ...
                deform_image_pair(image_raw_01, image_raw_02, ...
                source_grid_x, source_grid_y, ...
                source_displacement_x, source_displacement_y, ...
                deform_interpolation_method);
        end
    end
    
    % Extract the regions
    region_mat_01 = extract_sub_regions(image_01, ...
        [region_height, region_width], ...
        grid_correlate_x, grid_correlate_y);
    region_mat_02 = extract_sub_regions(image_02, ...
        [region_height, region_width], ...
        grid_correlate_x, grid_correlate_y);
    
    % Inform the user that correlations 
    % are about to happen.
    fprintf(1, 'Correlating image pair...\n');
    
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
                
        % Switch between spatial and spectral ensemble
        switch lower(ensemble_domain_string)
            case 'spatial'
                % For spatial ensemble, take the inverse
                % FT of the spectral correlation (i.e., the spatial
                % correlation) and add this to the purely real 
                % ensemble correlation
                %
                % Add the correlation to the ensemble
                % (spatial domain)
                cross_corr_ensemble(:, :, k) = ...
                    cross_corr_ensemble(:, :, k) + ...
                    fftshift(abs(ifft2(cross_corr_spectral)));
                
            case 'spectral'   
                % For spectral ensemble, add the current complex
                % correlation to the ensemble complex correlation
                cross_corr_ensemble(:, :, k) = ...
                    cross_corr_ensemble(:, :, k) + ...
                    fftshift(cross_corr_spectral);
        end 
    end  
    
    % Print a carriage return after
    % the image pair is done processing
    fprintf(1, '\n');
end

% If the spectral ensemble was performed,
% then the spectal ensemble correlations
% need to be inverse-Fourier transformed
% back into the spatial domain. 
% This checks which type of ensemble was run
% (spatial or spectral) and does the inverse
% transform if necessary. Note that this transform
% happens in-place, i.e., the value of 
% the variable cross_corr_ensemble is changed
% after this result, rather than the transformed
% correlations being saved as a separate variable.
% This is to save memory, and also to reduce
% the number of variables we have to keep track of.
switch lower(ensemble_domain_string)
    case 'spectral'
        % Do the inverse transform for each region.
        for k = 1 : num_regions_correlate
            cross_corr_ensemble(:, :, k) = fftshift(abs(ifft2(cross_corr_ensemble(:, :, k))));
        end  
end


% Allocate arrays to hold vectors
tx_temp = zeros(num_regions_full, 1);
ty_temp = zeros(num_regions_full, 1);

% After adding all the pairs to the ensemble
% do the subpixel peak detection.
for k = 1 : num_regions_correlate
    
    % Extract the grid index
    grid_index = grid_indices(k);
        
    % Do the subpixel displacement estimate.
%     [tx_raw_full(grid_index), ty_raw_full(grid_index)] = subpixel(cross_corr_ensemble(:, :, k),...
%             region_width, region_height, sub_pixel_weights, ...
%                 1, 0, particle_diameter * [1, 1]);

    [tx_temp(grid_index), ty_temp(grid_index)] = subpixel(cross_corr_ensemble(:, :, k),...
            region_width, region_height, sub_pixel_weights, ...
                1, 0, particle_diameter * [1, 1]);
            
    % Add to the calculated displacement
    % whatever source displacement 
                       
end

% Resample the source displacement
% from the source grid
% onto the current grid.
[source_field_interp_tx, source_field_interp_ty] = ...
    resample_vector_field(...
    source_grid_x, source_grid_y, ...
    source_displacement_x, source_displacement_y, ...
    grid_full_x, grid_full_y);

% Add the source displacement from
% the iterative method to
% the measured displacement
tx_raw_full = tx_temp + source_field_interp_tx;
ty_raw_full = ty_temp + source_field_interp_ty;

% Save the results to the structure
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.X(:, 1) = ...
    tx_raw_full;
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.Y(:, 1) = ...
    ty_raw_full;

% Do the validation if requested
do_validation = JOBFILE.Processing(PASS_NUMBER).Validation.DoValidation;

% Do validation if requested
if do_validation == true;
    
    % Inform the user
    fprintf(1, 'Validating vector field...\n');
    
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
    fprintf(1, 'Smoothing vector field...\n');
    
    % Extract the smoothing parameters
    smoothing_kernel_diameter = JOBFILE.Processing(PASS_NUMBER).Smoothing.KernelDiameter;
    smoothing_kernel_std = JOBFILE.Processing(PASS_NUMBER).Smoothing.KernelStdDev;

    % Calculate smoothed field
    tx_smoothed_full = smoothField(tx_temp_full, smoothing_kernel_diameter, smoothing_kernel_std);
    ty_smoothed_full = smoothField(ty_temp_full, smoothing_kernel_diameter, smoothing_kernel_std);
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.X = tx_smoothed_full;
    JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.Y = ty_smoothed_full;

end

% Plotting for debugging

nx = length(unique(grid_full_x));
ny = length(unique(grid_full_y));

tx_mat = reshape(tx_smoothed_full, [ny, nx]);

imagesc(grid_full_x, grid_full_y, tx_mat);
hold on
quiver(grid_full_x, grid_full_y, tx_smoothed_full, ty_smoothed_full, 2, 'black', 'linewidth', 2);
axis image;
hold off
drawnow;


end













