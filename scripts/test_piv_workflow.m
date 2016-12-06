

% Add paths
addpaths();

% Load the job list
% JobList = PIVJobList_synthetic();
% JobList = PIVJobList();

JobList = make_piv_job_list();

% Run the job list
JobList_output = run_piv_job_list(JobList);

plot_piv_job_list(JobList);