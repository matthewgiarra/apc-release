
function JobList = update_job_list(JobList)

% JobList = PIVJobList_pivchallenge_ensemble_multi_job_linux;

num_jobs = length(JobList);

for n = 1 : num_jobs
   
    % Get the path to the jobfile
    JobFilePath = determine_jobfile_save_path(JobList(n));
    
    % Load the jobfile
    load(JobFilePath);
    
    % Read the start pass
    start_pass = JobFile.JobOptions.StartPass;
    
    % Replace the blank processing info with info
    % from the loaded jobfile.
    for p = 1 : start_pass-1
        JobList(n).Processing(p) = JobFile.Processing(p); 
    end
        
end

end
