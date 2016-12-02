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

% Number of pairs to correlate
num_regions_correlate = length(grid_correlate_x);

% Number of pairs to correlate
num_pairs_correlate = read_num_pairs(JOBFILE, PASS_NUMBER);

% Region sizes
[region_height, region_width] = get_region_size(JOBFILE, PASS_NUMBER);

% Make the spatial windows
[spatial_window_01, spatial_window_02] = ...
    make_spatial_windows(JOBFILE, PASS_NUMBER);

% Ensemble domain string
ensemble_domain_string = lower(read_ensemble_domain(JOBFILE, PASS_NUMBER));

% Allocate correlation planes
switch lower(ensemble_domain_string)
    case 'spectral'
        
    % Allocate complex array for correlations
    ensemble_corr_spatial = zeros(...
        region_height, region_width, num_regions_correlate) + ...
        1i * zeros(region_height, region_width, num_regions_correlate);
    
    % Allocate purely real array for correlations
    case 'spatial'
        ensemble_corr_spatial = zeros(...
            region_height, region_width, num_regions_correlate);
end

% Loop over all the images
for n = 1 : num_pairs_correlate
    
    % Image paths
    image_path_01 = JOBFILE.Processing(PASS_NUMBER).Frames.Paths{1}{n};
    image_path_02 = JOBFILE.Processing(PASS_NUMBER).Frames.Paths{2}{n};
    
    % Load the images
    image_raw_01 = double(imread(image_path_01));
    image_raw_02 = double(imread(image_path_02));
    
    % Deform parameters
    deform_source_grid_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.X;
    deform_source_grid_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.Y;
    
    deform_source_displacement_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.X;
    deform_source_displacement_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.Y;
    
    % Deform method
    deform_interpolation_method = JOBFILE.Processing(1).Iterative.Deform.Interpolation;
    
    % Deform the images if requested.
    [image_01, image_02] = ...
        deform_image_pair(image_raw_01, image_raw_02, ...
        deform_source_grid_x, deform_source_grid_y, ...
        deform_source_displacement_x, deform_source_displacement_y, ...
        deform_interpolation_method);
    
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
        FT_02 = fft2(spatial_window_01 .* (region_02 - mean(region_02(:))));
        
    end
    
end



end













