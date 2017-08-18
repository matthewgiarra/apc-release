function JOB_LIST_CHECK = verify_job_list_file_paths(JOBLIST)

 % Count the number of jobs
 num_jobs = length(JOBLIST);
 
% Create a vector to hold the file paths
frame_paths = {};
 
 % Loop over the jobs
 for n = 1 : num_jobs
     
    % Extract the job file
    JobFile = JOBLIST(n);
    
    % Count the number of passes
    num_passes = determine_number_of_passes(JobFile);
     
    % Loop over the passes
    for p = 1 : num_passes
        
        % Create image path list.
        JobFile = create_image_pair_path_list(JobFile, p);
        
        % Frame list cell aray
        frame_list_array = JobFile.Processing(p).Frames.Paths;
        
        % Number of frame lists (probably, usually, 2)
        num_lists = length(frame_list_array);
        
        % Loop over the frame lists
        for f = 1 : num_lists
           
            % Concatenate the file names to the 
            % path list structure
            frame_paths = cat(1, frame_paths, frame_list_array{f}(:));
            
        end 
    end 
 end
 

% Get the unique paths
frame_paths_unique = unique(frame_paths);
    
% Count the number of unique frames
num_frames = length(frame_paths_unique);

% Existence vector
frames_exist = zeros(num_frames, 1);

% Loop over the frame paths
for k = 1 : num_frames
    
    % Frame path
    frame_path = frame_paths_unique{k};
    
    % Frame exists
    
    % Check whether the frame exists
    frame_exists = exist(frame_path, 'file');
    
    if not(frame_exists)
        fprintf(1, 'File not found: %s\n', frame_path);
    end
    
    % Add to the vector
    frames_exist(k) = frame_exists;
    
end

% Output false if not all the frames were found,
% and true if all the frames were found.
JOB_LIST_CHECK = all(frames_exist);

end








