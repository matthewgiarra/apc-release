
JobList = PIVJobList_pivchallenge_ensemble_multi_job;

% Number of jobs
num_jobs = length(JobList);

% Loop over jobs
for k = 1 : num_jobs
    
   % Extract the job file
   JobFile = JobList(k);
   SourceFilePath = JobFile.Data.Inputs.SourceFilePath;
   StartPass = JobFile.JobOptions.StartPass;
   
   % Add pass
   JobFile = add_pass_to_jobfile(SourceFilePath, JobFile, StartPass);
   
   % Add it back in to the list.
   JobList(k) = JobFile;
    
end