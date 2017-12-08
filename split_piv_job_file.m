function JOBLIST = split_piv_job_file(JOBFILE, NUM_PROCS)

% Count the number of passes
num_passes = length(JOBFILE.Processing);

% Get the overall start and end frames
start_frame = JOBFILE.Processing(1).Frames.Start;
end_frame   = JOBFILE.Processing(1).Frames.End;
step_frame  = JOBFILE.Processing(1).Frames.Step;

% Figure out the start and end frames of each jobn
[frames_start, frames_end] = split_list(start_frame, end_frame, ...
    step_frame, NUM_PROCS, 1:NUM_PROCS);

% Number of jobs to make
num_jobs = length(frames_start);

% Copy the jobs
JOBLIST = repmat(JOBFILE, [num_jobs, 1]);

% Loop over the passes
for p = 1 : num_passes
    
    % Loop over the jobs
    for n = 1 : num_jobs       
        JOBLIST(n).Processing(p).Frames.Start = frames_start(n);
        JOBLIST(n).Processing(p).Frames.End   = frames_end(n);        
    end
end

end