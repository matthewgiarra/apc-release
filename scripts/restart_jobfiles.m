
function JobList = update_job_list()

JobList = PIVJobList_pivchallenge_ensemble_multi_job_linux;

num_jobs = length(JobList);

for n = 1 : num_jobs
   
    % Get the path to the jobfile
    JobFilePath = JobList(n).Data.Outputs.Vectors.Path;
    
    % Load the jobfile
    load(JobFilePath);
    
    start_pass = JobFile.JobOptions.StartPass;
    
    for p = 1 : start_pass-1
        JobList(n).Processing(p) = JobFile.Processing(p); 
    end
        
end

end
