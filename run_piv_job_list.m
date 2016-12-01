function run_piv_job_list(JOBLIST)

% First step: Verify that all files that the job
% refers to can be located on the current filesystem. 
% % % % WRITE THIS % % % % %
verify_job_list_file_paths(JOBLIST);
% % % % WRITE THIS % % % % %

% Count the number of jobs
num_jobs = length(JOBLIST);

% Loop over all the jobs
for n = 1 : num_jobs
   
    % Extract the job file
    JobFile = JOBLIST(n);
    
    % Determine the number of passes to run.
    num_passes = determine_number_of_passes(JobFile);
    
    
    % Loop over all the passes.
    for pass_number = 1 : num_passes
        % Build list of files to correlate
        
        
        %% Everything that doesn't depend on what correlation type
        %
        % First image to correlate
        [input_image_path_list_01, input_image_path_list_02] = create_image_pair_path_list(JobFile, pass_number);
        
         
        
        
        %% Everything that DOES depend on what correlation type
        
        
        
        
        
        
    end
    
    
end








end