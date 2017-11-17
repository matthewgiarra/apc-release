

job_file_to_restart_path = '/Users/matthewgiarra/Desktop/apc/A_apc_00001_00600.mat';

% Job to restart
jf = load(job_file_to_restart_path); 

SourceJobList = PIVJobList_pivchallenge_ensemble_multi_job;

SourceJob = SourceJobList(2);

JobFile = add_pass_to_jobfile(jf.JobFile, SourceJob);

run_piv_job_list(JobFile);