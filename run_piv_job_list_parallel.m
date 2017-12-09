function OUTPUT_FILE_PATHS = run_piv_job_list_parallel(JOBLIST_INPUT, dynamic_cores)

if nargin < 2
    dynamic_cores = false;
end


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

% Num cores
num_cores_ensemble = feature('numcores');
num_cores_instantaneous = 15;

% Loop over all the jobs
for n = 1 : num_jobs
    
    % Get pool size
    p = gcp('nocreate');
    if isempty(p)
        pool_size = 0;
    else
        pool_size = p.NumWorkers;
    end
    
    % Extract the job file
    JobFile = JOBLIST_INPUT(n);
    
    % Check whether to do ensemble
    do_ensemble = JobFile.Processing(1).Correlation.Ensemble.DoEnsemble;
   
    % Choose between doing the correlations in parallel (ensemble)
    % or doing the pairs in parallel (instantaneous)
    if do_ensemble
        
        if dynamic_cores
            if pool_size == 0
                parpool(num_cores_ensemble)
            elseif pool_size > 0 && pool_size ~= num_cores_ensemble
                delete(gcp);
                parpool(num_cores_ensemble)
            end
        end
        
        OUTPUT_FILE_PATHS{n} = run_piv_job_file(JobFile);
    else
        
        if dynamic_cores
            if pool_size == 0
                parpool(num_cores_instantaneous)
            elseif pool_size > 0 && pool_size ~= num_cores_instantaneous
                delete(gcp);
                parpool(num_cores_instantaneous)
            end
        end
        
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
    
end
t2 = toc(t1);

% Print the total time taken.
fprintf('Total job list time: %0.1f sec\n', t2);

end



