function [TY, TX, PARTICLE_DIAMETER_Y, PARTICLE_DIAMETER_X] = planes2vect(JOBFILE, PASS_NUMBER, PARALLEL)
% This function measures displacements (TY, TX) from
% a list of either real or complex correlation planes. 

if nargin < 3
    PARALLEL = false;
end

if PARALLEL
   parfor_arg = inf;
   parfor_arg_str = 'parallel';
else
    parfor_arg = 0;
    parfor_arg_str = 'serial';
end

% Read the ensemble type
ensemble_type_string = lower( ...
    get_ensemble_type(JOBFILE, PASS_NUMBER));

% Extract the correlation planes from the job file
cross_corr_array = JOBFILE.Processing(PASS_NUMBER).Correlation.CrossCorrPlanes;

% Extract the auto correlation arrays
auto_corr_array_01 = JOBFILE.Processing(PASS_NUMBER).Correlation.AutoCorrPlanes.Image1;
auto_corr_array_02 = JOBFILE.Processing(PASS_NUMBER).Correlation.AutoCorrPlanes.Image2;

% Check if all the imaginary components
% of the correlation array are equal to zero.
% If this is the case, then spectral plane fitting
% won't work.
planes_are_purely_real = all(imag(cross_corr_array(:)) == 0);

% Check whether correlation planes are complex.
if planes_are_purely_real
    % If planes are purely real, then automatically do the
    % displacement estimate in the spatial domain (peak finding)
   displacement_estimate_domain_string = 'spatial';
   ensemble_domain_string = 'spatial';
else
    % If planes are complex, then either spatial or
    % spectral displacement estimates will work.
    % In this case, determine the domain in which to
    % calculate displacement by reading the parameter
    % from the job file.
    displacement_estimate_domain_string = ...
        get_displacement_estimate_domain(JOBFILE, PASS_NUMBER);

    % Also set the "ensemble domain" specifier to "spectral"
    % so that the correct part of the switch/case statement
    % below gets chosen. 
    % This is a dumb way to handling this decision
    ensemble_domain_string = 'spectral';
end

% Spectral weighting method
spectral_weighting_method_string = ...
    lower(JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.Method);

% If the ensemble type was "spatial,"
% then add all the planes together
switch lower(ensemble_type_string)
    case 'spatial'
        % If the spatial correlation was specified,
        % then add all the correlations together. 
        cross_corr_array = sum(cross_corr_array, 3);
end

% Get the number of correlation planes remaining.
[region_height, region_width, num_correlation_planes] ...
    = size(cross_corr_array);

% Static particle diameters
% Particle diameter
particle_diameter = ...
   JOBFILE.Processing(PASS_NUMBER). ...
   Correlation.EstimatedParticleDiameter;

% Allocate the static spectral filter
% This apparently needs to be done 
% so that the parallel loop can run
spectral_weighting_filter_static = nan(region_height, region_width);

% Make the list of particle diameters
% for the static methods
particle_diameter_list_x = zeros(num_correlation_planes, 1);
particle_diameter_list_y = zeros(num_correlation_planes, 1);

% Set the diameters
particle_diameter_list_x(:) = particle_diameter;
particle_diameter_list_y(:) = particle_diameter;

% Specifying these here so that the parfor loop can run.
% They'll be replaced with jobfile-specified options
% if they're needed.
apc_method = 'magnitude';
spc_unwrap_method_string = 'goldstein';
spc_run_compiled = false;

% Make a grid
xv = (1 : region_width) - fourier_zero(region_width);
yv = (1 : region_height) - fourier_zero(region_height);

% Make coordinate arrays
[X, Y] = meshgrid(xv, yv);

% Diameter thresholds
% Minimum size on the APC filter (x-direction)
dp_thresh_min_x = JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.APC.Thresh.X(1);

% Maximium size on the APC filter (x-direction)
dp_thresh_max_x = JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.APC.Thresh.X(2);

% Minimum size on the APC filter (y-direction)
dp_thresh_min_y = JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.APC.Thresh.Y(1);

% Maximium size on the APC filter (y-direction)
dp_thresh_max_y = JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.APC.Thresh.Y(2);

% Method specific options
switch lower(spectral_weighting_method_string)
    case 'rpc'   
        % Create the RPC filter
        spectral_weighting_filter_static = spectral_energy_filter( ...
            region_height, region_width, particle_diameter);
    case 'gcc'
    % Create the GCC filter (ones everywhere)
    spectral_weighting_filter_static = ones(region_height, region_width);
    
    case 'apc' 
        
        % Get grid indices where correlations are performed
        inds = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.Indices;
        
        % If APC was selected, then check the APC method.
        % Read the APC method
        apc_method = JOBFILE.Processing(PASS_NUMBER). ...
            Correlation.SpectralWeighting.APC.Method;
                
        % Get the grid points
        gx = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X;
        gy = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.Y;
        
        % Allocate cross correlation particle diameters
        % for all the grid points
        dp_cc_full_x = nan(size(gx));
        dp_cc_full_y = nan(size(gy));
        
        % Allocate autocorrelation particle diameters
        % for all the grid points
        dp_ac_full_x = nan(size(gx));
        dp_ac_full_y = nan(size(gy));
        
        % Allocate cross correlation particle diameters
        % just for the correlated grid points
        dp_cc_x = zeros(size(inds));
        dp_cc_y = zeros(size(inds));
        
        % Allocate autocorrelation particle diameters
        % just for the correlated grid points
        dp_ac_x = zeros(size(inds));
        dp_ac_y = zeros(size(inds));
        
        % Inform the user
        fprintf(1, 'Calculating APC filters (%s processing)...\n',...
            parfor_arg_str);
        
        % Loop over all the planes
        parfor(k = 1 : num_correlation_planes, parfor_arg)
            
            % Extract the given region
            cross_corr_spectral = cross_corr_array(:, :, k);
            
            % Auto correlation of the region from image 1
            ac_01 = auto_corr_array_01(:, :, k);
            
            % Auto correlation of the region from image 2
            ac_02 = auto_corr_array_02(:, :, k);
            
            % Product of auto correlations
            ac_prod = sqrt(abs(ac_01 .* ac_02));
            
            % Calculate the autocorrelation APC filter
            [~, ac_filter_std_y, ac_filter_std_x] = ...
                calculate_apc_filter_magnitude_method(ac_prod);
            
            % Calculate the APC filter
            [~, cc_filter_std_y, cc_filter_std_x] = ...
                calculate_apc_filter(cross_corr_spectral, ...
                particle_diameter, apc_method);

            % Equivalent particle diameter in the columns
            % direction, calculated from the APC filter.
            dp_cc_x(k) = filter_std_dev_to_particle_diameter(...
                cc_filter_std_x, region_width);

            % Equivalent particle diameter in the rows
            % direction, calculated from the APC filter.
            dp_cc_y(k) = filter_std_dev_to_particle_diameter(...
                cc_filter_std_y, region_height);
            
            % Equivalent particle diameter in the columns
            % direction, calculated from the autocorrelation.
            dp_ac_x(k) = filter_std_dev_to_particle_diameter(...
                ac_filter_std_x, region_width);
            
            % Equivalent particle diameter in the columns
            % direction, calculated from the autocorrelation.           
            dp_ac_y(k) = filter_std_dev_to_particle_diameter(...
                ac_filter_std_y, region_width);
            
        end
        
        % Put the calculated particle sizes from the
        % cross correlation filters into the full list 
        % of cross correlation diameters
        dp_cc_full_x(inds) = dp_cc_x;
        dp_cc_full_y(inds) = dp_cc_y;
        
        % Put the calculated particle sizes from the
        % autocorrelation filters into the full list 
        % of autocorrelation diameters
        dp_ac_full_x(inds) = dp_ac_x;
        dp_ac_full_y(inds) = dp_ac_y;
        
        % Run UOD validation on the cross correlation filters
        [dp_cc_val_x, dp_cc_val_y, outlier_flags_cc] = ...
                validateField_prana(gx, gy, dp_cc_full_x, dp_cc_full_y, 0.5 * [1, 1]);
            
        % Run UOD validation on the autocorrelation filters   
        [dp_ac_val_x, dp_ac_val_y, outlier_flags_ac] = ...
                validateField_prana(gx, gy, dp_ac_full_x, dp_ac_full_y, 0.5 * [1, 1]);
        
        % Find the indices of masked grid points
        mask_inds = setdiff(1 : numel(gx), inds);
        
        % Set masked indices to nan
        % (they come out of validateField_prana as zeros)
        dp_cc_val_x(mask_inds) = nan;
        dp_cc_val_y(mask_inds) = nan;
        dp_ac_val_x(mask_inds) = nan;
        dp_ac_val_y(mask_inds) = nan;
        
        % Replace thresholded filters with the AC filters (x-direction)
        dp_cc_val_x(dp_cc_val_x < dp_thresh_min_x | ...
                          dp_cc_val_x > dp_thresh_max_x) = ...
                          dp_ac_val_x(dp_cc_val_x < dp_thresh_min_x | ...
                          dp_cc_val_x > dp_thresh_max_x);
                          
        % Replace thresholded filters with the AC filters (y-direction)                  
        dp_cc_val_y(dp_cc_val_y < dp_thresh_min_y | ...
                          dp_cc_val_y > dp_thresh_max_y) = ...
                          dp_ac_val_y(dp_cc_val_y < dp_thresh_min_y | ...
                          dp_cc_val_y > dp_thresh_max_y);
                      
        % Combine the outlier flags
        outlier_flags_combined = max(outlier_flags_cc, outlier_flags_ac);
                      
        % Run outlier replacement once more
        [dp_cc_val_x, dp_cc_val_y, ~] = ...
            validateField_prana(gx, gy, ...
            dp_cc_val_x, dp_cc_val_y, ...
            0.5 * [1, 1], outlier_flags_combined);
        
        % Replace with nans again
        dp_cc_val_x(mask_inds) = nan;
        dp_cc_val_y(mask_inds) = nan;
          
        % Replace remaining "outliers" with user-defined particle diameter
        dp_cc_val_x(dp_cc_val_x < dp_thresh_min_x | ...
                          dp_cc_val_x > dp_thresh_max_x) = particle_diameter;            
        dp_cc_val_y(dp_cc_val_y < dp_thresh_min_y | ...
                          dp_cc_val_y > dp_thresh_max_y) = particle_diameter;
                               
        % Raw particle diameters
        particle_diameter_list_raw_x = dp_cc_full_x;
        particle_diameter_list_raw_y = dp_cc_full_y;
            
        % Validated particle diameters
        particle_diameter_list_x = dp_cc_val_x(inds);
        particle_diameter_list_y = dp_cc_val_y(inds);
        
        
    case 'hybrid'
        % Hybrid spectral weighting.
        % In this scheme, we load a file that contains the pre-computed
        % spectral weights for each interrogation region
        
        % Get the indicies of the regions
        inds = JOBFILE.Data.Inputs.SourceJobFile.Processing(PASS_NUMBER). ...
            Grid.Points.Correlate.Indices;
        
        % Get the filter diameters
        particle_diameter_list_x = JOBFILE.Data.Inputs.SourceJobFile.Processing(PASS_NUMBER). ...
            Results.Filtering.APC.Diameter.X(inds, 1);
        particle_diameter_list_y = JOBFILE.Data.Inputs.SourceJobFile.Processing(PASS_NUMBER). ...
            Results.Filtering.APC.Diameter.Y(inds, 1);
end

% Allocate arrays to hold vectors
TX = nan(num_correlation_planes, 1);
TY = nan(num_correlation_planes, 1);

% Allocate the subpixel weights
sub_pixel_weights = ones(region_height, region_width);

% Get SPC parameters if requested
switch lower(displacement_estimate_domain_string)
    case 'spectral'  
        % Get the list of kernel sizes for the SPC 
        spc_unwrap_method_string = ...
            get_spc_unwrap_method(JOBFILE, PASS_NUMBER);
        
        % Choose whether to run compiled codes for SPC
        spc_run_compiled = JOBFILE.Processing(PASS_NUMBER). ...
            Correlation.DisplacementEstimate. ...
            Spectral.RunCompiled;
        
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

% spectral_filter_temp = zeros(region_height, region_width);


switch lower(ensemble_domain_string)
    case 'spectral'
        
        % Inform the user
        fprintf(1, 'Calculating inverse FTs...\n');
        % Do the inverse transform for each region.
        parfor(k = 1 : num_correlation_planes, parfor_arg)
            
            % Extract the given region
            cross_corr_spectral = cross_corr_array(:, :, k);
            
            % Spectral correlation phase and magnitude
            [spectral_corr_phase, spectral_corr_mag] = ...
                split_complex(cross_corr_spectral);
                        
            % Switch between correlation methods
            switch lower(spectral_weighting_method_string)
                case 'scc'           
                    spectral_filter_temp = spectral_corr_mag;
                    
                case {'apc', 'hybrid'}  
                                    
                    % Standard deviations of the
                    % correlation weighting filter (horizontal)
                    apc_std_dev_x = ...
                        particle_diameter_to_filter_std_dev(...
                        particle_diameter_list_x(k), region_width);
                    
                    % Standard deviations of the
                    % correlation weighting filter (vertical)                    
                    apc_std_dev_y = ...
                        particle_diameter_to_filter_std_dev(...
                        particle_diameter_list_y(k), region_height);
                
                   % Make the spectral filter
                    spectral_filter_temp = ...
                        exp(-X.^2 / (2 * apc_std_dev_x^2) - ...
                        Y.^2 / (2 * apc_std_dev_y^2));
        
                otherwise
                    spectral_filter_temp = spectral_weighting_filter_static;
            end
            
            % Switch between estimating the 
            % displacement in the spatial domain (peak finding)
            % or in the spectral domain (plane fitting)
            switch lower(displacement_estimate_domain_string)
                case 'spatial'                    
                    % Apply the phase filter to the spectral plane.
                    % Note that this operation is legitimate even
                    % if SCC or GCC is selected. The reason for this
                    % is that if SCC is selected, then the "filter"
                    % is just the original magnitude. 
                    % I (Matt Giarra) have coded it this way to
                    % simplify the control flow. Not sure if this will
                    % turn out to be a nice way to do it.
                    cross_corr_filtered_spectral = ...
                    spectral_filter_temp .* spectral_corr_phase;

                    % Take the inverse FT of the "filtered" correlation.
                    cross_corr_filtered_spatial = fftshift(abs(ifft2(fftshift(...
                                cross_corr_filtered_spectral)))); 
                            
                    % Effective particle diameters
                    dp_x = particle_diameter_list_x(k);
                    dp_y = particle_diameter_list_y(k);

                    % Do the subpixel displacement estimate.
                    [TX(k), TY(k)] = ...
                        subpixel(cross_corr_filtered_spatial,...
                            region_width, region_height, sub_pixel_weights, ...
                                1, 0, [dp_x, dp_y]);              
                
                % If the displacement-estimate domain
                % was specified as "spectral" then
                % do the SPC plane fit to estimate the
                % pattern displacement.
                case 'spectral'    
                    % Calculate the displacement in the Fourier domain
                    % by unwrapping the phase angle and
                    % fitting a plane to it.
                    [TY(k), TX(k)] = spc_2D(...
                        cross_corr_spectral, ...
                        spectral_filter_temp, ...
                        spc_unwrap_method_string, ...
                        spc_run_compiled);
            end                 
        end
        
    % This is the case for ensembles done in the spatial
    % domain rather than the spectral domain. This case
    % assumes that the correlation planes passed are
    % purely real. 
    otherwise
        
        % If the displacement estimate was specified
        % to occur in the spatial domain (peak finding)
        % then do the subpixel peak fitting. 
        % For now the three-point Gaussian fit is hard coded.
        % This should be changed.
        switch lower(displacement_estimate_domain_string)
            case 'spatial'
                % Loop over the planes
                for k = 1 : num_correlation_planes
                    cross_corr_spatial = cross_corr_array(:, :, k);

                    % Effective particle diameters
                    dp_x = particle_diameter_list_x(k);
                    dp_y = particle_diameter_list_y(k);

                    % Do the subpixel displacement estimate.
                    [TX(k), TY(k)] = ...
                        subpixel(cross_corr_spatial,...
                        region_width, region_height, sub_pixel_weights, ...
                        1, 0, [dp_x, dp_y]);   
                end
        end
end

% Save the particle diameters
PARTICLE_DIAMETER_Y = particle_diameter_list_y;
PARTICLE_DIAMETER_X = particle_diameter_list_x;

end


