function run_piv_job_file_ensemble(JOBFILE)

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);
   
% Loop over all the passes.
for p = 1 : num_passes
    % Build list of files to correlate

    %% Everything that doesn't depend on what correlation type
    %
    % Images to correlate
    [input_image_path_list_01, input_image_path_list_02] = create_image_pair_path_list(JOBFILE, p);
    
    % Grid the image
    [grid_x{p}, grid_y{p}] = gridImage(JOBFILE, p);
    

   
    % Make the spatial windows
    [spatial_window_01{p}, spatial_window_02{p}] = ...
        make_spatial_windows(JOBFILE, p);
    
    % Count the number of regions
    num_regions = length(grid_x{p});
    
    % Number of grid points in each direction
    num_regions_x{p} = length(unique(grid_x{p}(:)));
    num_regions_y{p} = length(unique(grid_y{p}(:)));
    
    % Number of image pairs
    num_pairs = length(input_image_path_list_01);
    
    % Ensemble correlation
    do_ensemble_correlation = JOBFILE.Processing(p).Correlation.Ensemble.DoEnsemble;
        
    % Allocate arrays for the ensemble
    % correlation displacements
    % for all of the regions
    % even the masked ones
    % This is so the grid is compatible
    % with UOD, deform etc.
    tx_raw{p} = nan(num_regions, num_pairs);
    ty_raw{p} = nan(num_regions, num_pairs);
    
    
    
      
    
    %% Everything that DOES depend on what correlation type


end
   
end