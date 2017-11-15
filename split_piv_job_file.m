function JOBLIST = split_piv_job_file(JOBFILE, NUM_PROCS)

% Count the number of passes
num_passes = length(JOBFILE.Processing);

start_frame = JOBFILE.Processing(1).Frames.Start;
end_frame   = JOBFILE.Processing(1).Frames.End;
step_frame  = JOBFILE.Processing(1).Frames.Step;

% All frames
frames_all = start_frame : step_frame : end_frame;

% Count the number of frames
num_frames = length(frames_all);

% Set number of processors to not exceed the number of frames
num_procs = min(NUM_PROCS, num_frames);

% Number of frames per machine
num_procs_per_machine = ceil(num_frames / num_procs);

% Start frames on each job
frames_start = start_frame : num_procs_per_machine : end_frame;

% Number of jobs to make
num_jobs = length(frames_start);

% Copy the jobs
JOBLIST = repmat(JOBFILE, [num_jobs, 1]);

% Loop over the passes
for p = 1 : num_passes
    
    for n = 1 : num_jobs
        
        start_frame_current = frames_start(n);
        end_frame_current = min(end_frame, start_frame_current + num_procs_per_machine - 1);
        
        JOBLIST(n).Processing(p).Frames.Start = start_frame_current;
        JOBLIST(n).Processing(p).Frames.End = end_frame_current;
        
    end
    
end


end