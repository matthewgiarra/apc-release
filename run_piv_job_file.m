function run_piv_job_file(JOBFILE)

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);
   
% Loop over all the passes.
for p = 1 : num_passes
    % Build list of files to correlate
    
    % Inform the user that the pass is running
    fprintf(1, 'Pass %d of %d\n', p, num_passes);

    %% Everything that doesn't depend on what correlation type
    %
    % Update the job file with images to correlate
    JOBFILE = create_image_pair_path_list(JOBFILE, p);
    
    % Grid stuff
    
    % Grid the image
    JOBFILE = grid_image(JOBFILE, p);
    
    % Run the pass. 
    JOBFILE = run_correlation_pass(JOBFILE, p);

    
    % Print a carriage return after the pass compeltes.
    fprintf(1, '\n');
    
    % Run the PIV pass
% % % % % % %     %
% % % % % % %     % Was deform specified?
% % % % % % %     % Deform parameters
% % % % % % %     if p > 1
% % % % % % %         % On subsequent passes, make a deform structure to
% % % % % % %         % give to the APC filter code
% % % % % % %         deform_params.Grid.X = gx{p-1};
% % % % % % %         deform_params.Grid.Y = gy{p-1};
% % % % % % %         deform_params.Displacement.Y = ty_smoothed_apc{p-1}(:, end);
% % % % % % %         deform_params.Displacement.X = tx_smoothed_apc{p-1}(:, end);
% % % % % % %         deform_params.Method = deform_method;
% % % % % % %     else
% % % % % % %         % On the first pass, make an empty deform parameters structure.
% % % % % % %         deform_params = [];
% % % % % % %     end
    
    
    
    %   
%     % Subpixel weights (this is a leftover requirement from Prana)
%     subpixel_weights_array = ones(region_height, region_width);
%     
%      % Make the spatial windows
%     [spatial_window_01{p}, spatial_window_02{p}] = ...
%         make_spatial_windows(JOBFILE, p);
    
%     
%     % Count the total number of grid points
%     num_regions = length(grid_x{p});
%     
%     % Number of grid points in each direction
%     num_regions_x{p} = length(unique(grid_x{p}(:)));
%     num_regions_y{p} = length(unique(grid_y{p}(:)));
%     
%     % Allocate arrays for the 
%     % correlation displacements
%     % for all of the regions,
%     % even the masked ones
%     % This is so the grid is compatible
%     % with UOD, deform etc.
%     tx_raw{p} = nan(num_regions, num_pairs);
%     ty_raw{p} = nan(num_regions, num_pairs);
%     
%     % Validated fields
%     tx_val{p} = nan(num_regions, num_pairs);
%     ty_val{p} = nan(num_regions, num_pairs);
%     
%     % Smoothed fields
%     tx_smoothed{p} = zeros(num_regions, num_pairs);
%     ty_smoothed{p} = zeros(num_regions, num_pairs);
%     
%     % Outlier identification array
%     is_outlier{p} = zeros(num_regions, num_pairs);
%         
%     % Number of regions to correlate
%     num_regions_correlate = length(grid_x_correlate);
%     
%     % Allocate arrays for the ensemble
%     % correlation displacements
%     % for only the correlated regions
%     tx_valid = zeros(num_regions_correlate, 1);
%     ty_valid = zeros(num_regions_correlate, 1);
%     
%     % Ensemble correlation
%     do_ensemble_correlation = JOBFILE.Processing(p).Correlation.Ensemble.DoEnsemble;
%     
    %% Everything that DOES depend on what correlation type
    


end
   
end










