function run_piv_job_list(JOBLIST)

% First step: Verify that all files that the job
% refers to can be located on the current filesystem. 
% % % % WRITE THIS % % % % %%
% Things to test: 
verify_job_list_file_paths(JOBLIST);
% 
% 1) Check existences of all files
%   - Flow images
%   - Mask images
%   - Vector fields for iterative methods
% 2) Check compatibility of iterative methods?
% % % % WRITE THIS % % % % %

% Count the number of jobs
num_jobs = length(JOBLIST);

% Loop over all the jobs
for n = 1 : num_jobs
    
    % Extract the job file
    JobFile = JOBLIST(n);
    
    % Run the PIV job file
    run_piv_job_file(JobFile);
   
    
end








end