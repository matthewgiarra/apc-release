function run_piv_job_file(JOBFILE)

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);
    
    
    % Loop over all the passes.
    for pass_number = 1 : num_passes
        % Build list of files to correlate
        
        %% Everything that doesn't depend on what correlation type
        %
        % First image to correlate
        [input_image_path_list_01, input_image_path_list_02] = create_image_pair_path_list(JOBFILE, pass_number);
        
        
        %% Everything that DOES depend on what correlation type
        
        
    end
   
end