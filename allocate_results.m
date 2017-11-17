function JOBFILE = allocate_results(JOBFILE, PASS_NUMBER)

% Default to pass number of 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Read the image lists
image_paths_list_full = JOBFILE.Processing(PASS_NUMBER).Frames.Paths;

% These are the paths to the images
image_paths_list_01 = image_paths_list_full{1};

% Measure the number of images to correlate
num_pairs_correlate = length(image_paths_list_01);

% Extract the full list of grid points (masked AND unmasked)
grid_full_x = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X;

% Count the number of points to correlate
num_regions_full = length(grid_full_x);

% Make the results fields
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.X = nan(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Raw.Y = nan(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.X = nan(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.Y = nan(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Validated.IsOutlier = zeros(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.X = zeros(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Smoothed.Y = zeros(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Final.X = zeros(num_regions_full, num_pairs_correlate);
JOBFILE.Processing(PASS_NUMBER).Results.Displacement.Final.Y = zeros(num_regions_full, num_pairs_correlate);

% Read the correlation method
spectral_weighting_method = lower(get_spectral_weighting_method(JOBFILE, PASS_NUMBER));

% Allocate APC diameters
switch lower(spectral_weighting_method)
    case 'apc'
        JOBFILE.Processing(PASS_NUMBER).Results.Filtering.APC.Diameter.X ...
            = nan(num_regions_full, num_pairs_correlate);
        JOBFILE.Processing(PASS_NUMBER).Results.Filtering.APC.Diameter.Y ...
            = nan(num_regions_full, num_pairs_correlate);
end


end