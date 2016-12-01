function run_piv_job_list(JOBLIST)


% Count the number of jobs
num_jobs = length(JOBLIST);

% Loop over all the jobs
for n = 1 : num_jobs
   
    % Extract the job file
    JobFile = JOBLIST(n);
    
    % Determine the number of passes to run.
    num_passes = determine_number_of_passes(JobFile);
    
    
    % Loop over all the passes.
    for p = 1 : num_passes
        % Build list of files to correlate
        
        
        %% Everything that doesn't depend on what correlation type
        %
        % First image to correlate
        start_image_correlate = 
        
        
        %% Everything that DOES depend on what correlation type
        
        
        
        
        
        
    end
    
    
end








end