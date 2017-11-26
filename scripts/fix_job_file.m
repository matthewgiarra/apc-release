

% Specify the job file
job_file_path = '/Users/matthewgiarra/Desktop/job_files_to_fix/A_raw_apc_ensemble_00001_00600.mat';

% Load it
load(job_file_path);

% Number of passes
num_passes = length(JobFile.Processing);

for p = 1 : num_passes
   
    % Read the APC diameters
    % The x and y diameters are out of whack
    % in these two lines because they were 
    % accidentally reversed in the processing.
    sy_temp = JobFile.Processing(p).Results.Filtering.APC.Diameter.X;
    sx_temp = JobFile.Processing(p).Results.Filtering.APC.Diameter.Y;
    
    % Replace them
    JobFile.Processing(p).Results.Filtering.Diameter.X = sx_temp;
    JobFile.Processing(p).Results.Filtering.Diameter.Y = sy_temp;
    
    % Remove the APC field from the filtering field.
    JobFile.Processing(p).Results.Filtering = ...
        rmfield(JobFile.Processing(p).Results.Filtering, 'APC');
    
    % Delete the correlation planes
    % so that the file isn't 2 GB
    JobFile.Processing(p).Correlation = ...
        rmfield(JOBFILE.Processing(p).Correlation, 'CrossCorrPlanes');
    JobFile.Processing(p).Correlation = ...
        rmfield(JOBFILE.Processing(p).Correlation, 'AutoCorrPlanes');

end

save(job_file_path, 'JobFile', '-v7.3');