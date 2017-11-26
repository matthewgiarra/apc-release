function OUTPUT_FILE_PATHS = run_piv_job_list_parallel(JOBLIST_INPUT)

% First step: Verify that all files that the job
% refers to can be located on the current filesystem. 
% % % % WRITE THIS % % % % %%
% Things to test: 
job_list_is_valid = verify_job_list_file_paths(JOBLIST_INPUT);


% Only proceed if all images were found
if not(job_list_is_valid)
   error('Error: Files not found. Exiting.'); 
end

% 
% 1) Check existences of all files
%   - Flow images
%   - Mask images
%   - Vector fields for iterative methods
% 2) Check compatibility of iterative methods?
% % % % WRITE THIS % % % % %

% Count the number of jobs
num_jobs = length(JOBLIST_INPUT);

% Get parallel pool size
pool = gcp('nocreate');

% Get number of processors
poolsize = pool.NumWorkers;

% Start a timer
t1 = tic;

% Loop over all the jobs
for n = 1 : num_jobs
    
    % Extract the job file
    JobFile = JOBLIST_INPUT(n);
   
    % Split the job
    parallel_job_list = split_piv_job_file(JobFile, poolsize);
    
    % Number of parallel jobs
    num_parallel_jobs = length(parallel_job_list);
    
    % Parallel loop over the jobs
    parfor p = 1 : num_parallel_jobs
       
        % Extract the job
        parallel_job = parallel_job_list(p);
        
        % Run the parallel job
        output_file_paths_temp{n, p} = run_piv_job_file(parallel_job);        
    end
    
    [~, OUTPUT_FILE_PATHS{n}] = gather_job_file_results(JobFile, poolsize);
  
end
t2 = toc(t1);

% Print the total time taken.
fprintf('Total job list time: %0.1f sec\n', t2);

end



