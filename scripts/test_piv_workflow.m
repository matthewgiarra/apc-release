
% Add paths
addpaths();

% Load the job list
JobList = PIVJobList();

% Run the job list
JobList_output = run_piv_job_list(JobList);

