function sayantan_script(job_number_to_run)

% Default to running the first job.
if nargin < 1
    job_number_to_run = 1;
end

% Add jobfiles directory
addpath jobfiles;

% Load the jobfile
JobList = PIVJobList_pivchallenge_ensemble_new_grid_linux;

% Count the number of jobs in the job list
num_jobs = length(JobList);

if job_number_to_run > num_jobs
   error(['Error: the input argument "job_number_to_run" is greater than ' ...
       'the number of jobs in the job file (%s). Set job_number_to_run = 1 or 2.'], ...
       'jobfiles/PIVJobList_pivchallenge_ensemble_new_grid_linux.m') 
end

% Determine how many cores are available on the system
num_cores = feature('numcores');

% Check if a parallel pool is running
p = gcp('nocreate'); % If no pool, do not create new one.

% If no pool is running, create one
if isempty(p)
    
    % Create the pool
    parpool(num_cores);
else
    % If a pool is running, get its size.
    poolsize = p.NumWorkers;
    
    % Shut down the pool if it has fewer 
    % than the maximum number running.
    if poolsize < num_cores
        delete(gcp);
        parpool(num_cores);
    end
    
end

% Run the jobfile
run_piv_job_list(JobList(job_number_to_run));


end