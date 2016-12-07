function [APC_FILTER, FILTER_STD_DEV_Y, FILTER_STD_DEV_X, PHASE_ANGLE, PHASE_QUALITY] = ...
    calculate_apc_filter_phase_method(COMPLEX_CORRELATION,...
     RPC_DIAMETER, KERNEL_RADIUS)
	% This function computes the APC filter based on
    % the phase quality of a complex cross correlation.
    %
    % INPUTS
    %   COMPLEX_CORRELATION: [M x N] array (complex valued).
    %   This is the complex correlation in the spectral domain.
    %
    %   RPC_DIAMETER: Scalar value specifying
    %   the lower limit of the particle size
    %   that should be expected. This
    %   parameter places an upper limit
    %   on the size of the APC filter 
    %   in the spectral domain. Setting
    %   RPC_DIAMETER = 0 is allowed, 
    %   and doing so has the effect
    %   of not placing a limit on
    %   the standard deviation of
    %   the APC Filter. 
    %   If no value is input, then this
    %   variable defaults to RPC_DIAMETER = 0.
    %
    %   A smart way to use this feature
    %   could be to calculate an effective
    %   particle diameter from the images
    %   by some other means (e.g., autocorrelation)
    %   and then pass that value to this code,
    %   thereby limiting the APC diameter to a
    %   dynamically-calculated particle diameter.
    %   I (Matt Giarra) haven't impliement this yet.
    %   But you should do it.
    %
    %   KERNEL_RADIUS: Scalar value specifying the
    %   radius of the odd-sized kernel used for 
    %   calculating the phase quality. This code
    %   needs that value in order to properly 
    %   pad arrays for internal calculations.
    %   If no value is input, this variable defaults 
    %   to KERNEL_RADIUS = 2.  
    %
    % OUTPUTS
    %   APC_FILTER: [M x N] array (real valued).
    %   This is the Gaussian-shaped spectral correlation filter
    %   calculated by this code.
    %
    %   FILTER_STD_DEV_Y: Scalar value specifying the standard
    %   deviation of the Gaussian-shaped APC filter
    %   in the "rows" direction.
    %
    %   FILTER_STD_DEV_X: Scalar value specifying the standard
    %   deviation of the Gaussian-shaped APC filter
    %   in the "columns" direction. 
    %
    %   PHASE_ANGLE: [M x N] array (real valued).
    %   This is the angle of the phase of the 
    %   complex correlation. 
    %
    %   PHASE_QUALITY: [M x N] array (real valued).
    %   This is the "phase quality" of the angle
    %   of the phase of the complex correlation.
    %   Phase quality is calculated as the
    %   moving standard deviation of the 
    %   gradients of the phase angle plane.
    %   For details, see the book by Ghiglia & Pritt, 
    %   "Two-Dimensional Phase Unwrapping:
    %   Theory, Algorithms, and Software", 1998
    %   ISBN: 978-0-471-24935-1
    %
    % CAVEATS:
    %   In the current implementation, the APC filter
    %   is forced to be symmetric, 
    %   i.e., STD_DEV_Y = STD_DEV_X. 
	
    % Default kernel radius of 2
    if nargin < 3
        KERNEL_RADIUS = 2;
    end
    
    % Defualt to no maximum standard deviation
    if nargin < 2
        RPC_DIAMETER = 0;
    end
     
    % Kernel length
    kernel_length = 2 * KERNEL_RADIUS + 1;

    % Extract the phase of the
    % complex cross correlation
    [complex_corr_phase, ~] = ...
        split_complex(COMPLEX_CORRELATION);

    % Calculate the angle of the phase of the correlation.
    PHASE_ANGLE = angle(complex_corr_phase);

    % Calculate the phase quality
    PHASE_QUALITY = calculate_phase_quality(PHASE_ANGLE, kernel_length);
    
    % Extract the central portion of the phase quality
    phase_quality_interior = PHASE_QUALITY(...
        KERNEL_RADIUS + 1 : end - KERNEL_RADIUS - 1, ...
        KERNEL_RADIUS + 1 : end - KERNEL_RADIUS - 1);
    
    % Minimum subtraction of phase quality
    phase_quality_sub = (phase_quality_interior - ...
        min(phase_quality_interior(:)));
    
    % Rescale the phase quality so that its range is [0, 1]
    phase_quality_scaled = phase_quality_sub ./ max(phase_quality_sub(:));
    
    % Measure size of the phase quality array
	[phase_height, phase_width] = size(phase_quality_scaled);
    
    % Number of extra rows and columns
    % in the original correlation matrix
    % compared to the phase quality matrix
    % (the quality matrix is cropped)
    extra_rows = 2 * KERNEL_RADIUS + 1;
    extra_cols = 2 * KERNEL_RADIUS + 1;
    
    % Calculate the corresponding size
    % of the original interrogation regions
    region_height = phase_height + extra_rows;
    region_width  = phase_width  + extra_cols;
    
    % Max std dev for the filter
	max_std_dev_x = particle_diameter_to_filter_std_dev(RPC_DIAMETER, region_width);
    max_std_dev_y = particle_diameter_to_filter_std_dev(RPC_DIAMETER, region_height);
    max_std_dev = min(max_std_dev_x, max_std_dev_y);
    
    % Centroid of the phase coordinates
    xc_phase = fourier_zero(phase_width);
    yc_phase = fourier_zero(phase_height);
  
    % Coordinate vectors
    xv_phase = (1 : phase_width) - xc_phase;
    yv_phase = (1 : phase_height) - yc_phase;
    
    % Coordinate arrays
    [x_phase, y_phase] = meshgrid(xv_phase, yv_phase);
  
    % Coordinate for the filter
    yv_region = (1 : region_height) - fourier_zero(region_height);
    xv_region = (1 : region_width)  - fourier_zero(region_width);
    [x_region,  y_region] = meshgrid(xv_region, yv_region);
	
	% Make coordinates (polar),
	% with origin (r = 0) at geometric centroid of the region
	[~, r_phase] = cart2pol(x_phase, y_phase);
    
	% Threshold the phase quality map using histogram equalization
    phase_quality_bw = im2bw(phase_quality_scaled, 0.5);
	
    % Set border pixels to 1 to prevent connecting regions via the border
	phase_quality_bw(1, :) = 1;
	phase_quality_bw(end, :) = 1;
	phase_quality_bw(:, 1) = 1;
	phase_quality_bw(:, end) = 1;
	
	% Find properties of all the connected regions in the thresholded image. 
	phase_quality_region_props = ...
        regionprops(~phase_quality_bw, 'Centroid', 'PixelIdxList');
	
	% Count the number of regions
	num_regions = length(phase_quality_region_props);
	
	% Allocate a vector that will contain the median values
	% of the radial coordinates of each region.
	region_weighted_centroid_radial = zeros(num_regions, 1);
	
	% Allocate a vector to hold the centroids of the detected regions
	region_centroid_radial = zeros(num_regions, 1);
	
	% Allocate a vector to hold the mean values of the radial coordinates
	% of the pixels comprising the detected regions.
	region_radius_median = zeros(num_regions, 1);
	
	% Measure the median radial coordinate of each region
	for k = 1 : num_regions
		
		% Find the radial coordinate of the region's centroid.
		% whose value is equal to the k'th iteration of this loop
		region_centroid_subs = phase_quality_region_props(k).Centroid;
		
		% Radial coordinates of the pixels in the region
		region_radius_median(k) = median(r_phase(phase_quality_region_props(k).PixelIdxList));
		
		% Convert to radial
		region_centroid_radial(k) = sqrt((region_centroid_subs(1) - xc_phase)^2 + (region_centroid_subs(2) - yc_phase)^2);
		
		% Centroid coordinates weighted by the median radial coordinate of the pixels in the region
		region_weighted_centroid_radial(k) = region_radius_median(k) * region_centroid_radial(k);
	
	end
		
	% Find the minimum
	[~, region_weighted_centroid_idx_phase] = min(region_weighted_centroid_radial);
    
	% Mask indices in the phase matrix
    mask_idx_phase = phase_quality_region_props(...
        region_weighted_centroid_idx_phase).PixelIdxList;
    
	% Allocate a mask matrix
	phase_mask_holder = zeros(phase_height, phase_width);
	
	% Apply the mask
	phase_mask_holder(mask_idx_phase) = 1;
	
	% Zero the border pixels just in cae
	phase_mask_holder(:, 1) = 0 ;
	phase_mask_holder(:, end) = 0;
	phase_mask_holder(1, :) = 0;
	phase_mask_holder(end, :) = 0;

	% Fill the holes
	phase_mask_holder = imfill(phase_mask_holder);
    
    % Get the region properties again
    phase_mask_region_props = regionprops(phase_mask_holder,...
        'PixelIdxList', 'MajorAxisLength', 'MinorAxisLength', ...
        'Orientation');
    
    % Read the measured major axis of the ellipse
    % that best fits the binary quality mask
    ax_maj = phase_mask_region_props.MajorAxisLength;
    
    % Same for the minor axis
    ax_min = phase_mask_region_props.MinorAxisLength;
    
    % Gaussian standard deviations as fractions
    % of the major and minor axes of the ellipse fit
    % MAX_STD is the largest allowable standard deviation,
    % and a reasonable choice is, e.g., the 
    % standard deviation of the normal RPC filter.
    std_maj = ax_maj / 4.00;
    std_min = ax_min / 4.00;
    
	% If the standard deviations are reaaaaaly small,
	% then something probably went wrong. In this 
	% case, default to the maximum
	% specified standard deviation.
	if std_maj < 1
		std_maj = max_std_dev;
	end
	if std_min < 1
		std_min = max_std_dev;
	end
	
    % Standard deviation to use
    std_dev = min([std_maj, std_min, max_std_dev]);
	
    % Standard deviations
    FILTER_STD_DEV_X = std_dev;
    FILTER_STD_DEV_Y = std_dev;
    
    % This is the APC filter.
    APC_FILTER = exp((-(x_region).^2 -(y_region).^2 ) / (2 * std_dev^2));
    
end










