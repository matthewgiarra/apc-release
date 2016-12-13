function [TY, TX, PARTICLE_DIAMETER_Y, PARTICLE_DIAMETER_X] = planes2vect(JOBFILE, PASS_NUMBER)

% Read the ensemble domain string
ensemble_domain_string = read_ensemble_domain(JobFJOBFILEile, PASS_NUMBER);

% Read the ensemble direction
ensemble_direction_string = lower( ...
    read_ensemble_direction(JOBFILE, PASS_NUMBER));

% Extract the correlation planes from the job file
cross_corr_ensemble = JOBFILE.Processing(PASS_NUMBER).Correlation.Planes;

% Correlation filter
correlation_method_string = lower(JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.Method);

% If the ensemble direction was "spatial,"
% then add all the planes together
switch lower(ensemble_direction_string)
    case 'spatial'
        % If the spatial correlation was specified,
        % then add all the correlations together. 
        cross_corr_ensemble = sum(cross_corr_ensemble, 3);
end

% Get the number of correlation planes remaining.
[region_height, region_width, num_correlation_planes] ...
    = size(cross_corr_ensemble);

% Static particle diameters
% Particle diameter
particle_diameter = JOBFILE.Processing(PASS_NUMBER). ...
    SubPixel.EstimatedParticleDiameter;

% Method specific options
switch lower(correlation_method_string)
    case 'rpc'   
        % Read the RPC diameter
        rpc_diameter = ...
            JOBFILE.Processing(PASS_NUMBER). ...
            Correlation.RPC.EffectiveDiameter;
        
        % Particle diameter
        particle_diameter = rpc_diameter;
        
        % Create the RPC filter
        spectral_filter_static = spectral_energy_filter( ...
            region_height, region_width, rpc_diameter);
    case 'gcc'
    % Create the GCC filter (ones everywhere)
    spectral_filter_static = ones(region_height, region_width);
    
    case 'apc'
        % Set the upper bound for the filter
        apc_filter_upper_bound = JOBFILE.Processing(PASS_NUMBER). ...
            Correlation.APC.FilterDiameterUpperBound;
    
end

% Make the list of particle diameters
% for the static methods
particle_diameter_list_x = zeros(num_correlation_planes);
particle_diameter_list_y = zeros(num_correlation_planes);

% Set the diameters
particle_diameter_list_x(:) = particle_diameter;
particle_diameter_list_y(:) = particle_diameter;

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
        
        % Inform the user
        fprintf(1, 'Calculating inverse FTs...\n');
        % Do the inverse transform for each region.
        parfor k = 1 : num_correlation_planes
            
            % Extract the given region
            cross_corr_spectral = cross_corr_ensemble(:, :, k);
            
            % Spectral correlation phase and magnitude
            [spectral_corr_phase, spectral_corr_mag] = ...
                split_complex(cross_corr_spectral);
            
            % Switch between correlation methods
            switch lower(correlation_method)
                case 'scc'           
                    spectral_filter_temp = spectral_corr_mag;
                    
                case 'apc'       
                    % Calculate the APC filter
                    [spectral_filter_temp, filter_std_y, filter_std_x] = ...
                    calculate_apc_filter(cross_corr_spectral, ...
                    apc_filter_upper_bound, apc_method);
                
                    % Equivalent particle diameter in the columns
                    % direction, calculated from the APC filter.
                    particle_diameter_list_x(k) = filter_std_dev_to_particle_diameter(...
                        filter_std_x, region_width);
                    
                    % Equivalent particle diameter in the rows
                    % direction, calculated from the APC filter.
                    particle_diameter_list_y(k) = filter_std_dev_to_particle_diameter(...
                        filter_std_y, region_height);
                otherwise
                    spectral_filter_temp = spectral_filter_static;
            end
            
            % Apply the phase filter to the spectral plane.
            % Note that this operation is legitimate even
            % if SCC or GCC is selected. The reason for this
            % is that if SCC is selected, then the "filter"
            % is just the original magnitude. 
            % I (Matt Giarra) have coded it this way to
            % simplify the control flow. Not sure if this will
            % turn out to be a nice way to do it.
            cross_corr_spectral_filtered = ...
            spectral_filter_temp .* spectral_corr_phase;
                
            % Take the inverse FT of the "filtered" correlation.
            cross_corr_ensemble(:, :, k) = fftshift(abs(ifft2(fftshift(...
                        cross_corr_spectral_filtered))));                    
        end  
end

% Save the particle diameters
PARTICLE_DIAMETER_Y = particle_diameter_list_y;
PARTICLE_DIAMETER_X = particle_diameter_list_x;

% Allocate arrays to hold vectors
TX = nan(num_correlation_planes, 1);
TY = nan(num_correlation_planes, 1);

% Allocate the subpixel weights
sub_pixel_weights = ones(region_height, region_width);

% After adding all the pairs to the ensemble
% do the subpixel peak detection.
for k = 1 : num_correlation_planes
    
    % Effective particle diameters
    dp_x = particle_diameter_list_x(k);
    dp_y = particle_diameter_list_y(k);
      
    % Do the subpixel displacement estimate.
    [TX(k), TY(k)] = ...
        subpixel(cross_corr_ensemble(:, :, k),...
            region_width, region_height, sub_pixel_weights, ...
                1, 0, [dp_x, dp_y]);               
end

end