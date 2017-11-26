function [JOBFILE_GATHERED, OUTPUT_FILE_PATH] = gather_job_file_results(JOBFILE, poolsize)

    % Copy the input jobfile to the gathered jobfile
    JOBFILE_GATHERED = JOBFILE;
    
    % Number of passes
    num_passes = length(JOBFILE_GATHERED.Processing);
    
    % Loop over the passes and allocate the results
    for p = 1 : num_passes
        
        % Create image path list.
        JOBFILE_GATHERED = create_image_pair_path_list(JOBFILE_GATHERED, p);
        
        % Grid the image
        JOBFILE_GATHERED = grid_image(JOBFILE_GATHERED, p);

        % Allocate the results
        JOBFILE_GATHERED = allocate_results(JOBFILE_GATHERED, p);
        
    end
    
    % Now that the pass results have been allocated, loop over the files
    % and add their results
    job_list_parallel = split_piv_job_file(JOBFILE_GATHERED, poolsize);
    
    % Count the number of jobs it was split into
    num_parallel_jobs = length(job_list_parallel);
    
    % Starting frame index
    start_frame_idx = 1;
    
    % Loop over the jobs
    for n = 1 : num_parallel_jobs
        
        % Inform the user
        fprintf('Combining jobs, on %d of %d\n', n, num_parallel_jobs);
       
        % Get the path to the saved file
        saved_file_path =  determine_jobfile_save_path(job_list_parallel(n));
        
        % Load it
        jf_temp = load(saved_file_path);
        
        % Loop over the passes
        for p = 1 : num_passes
            
            % Read the displacements
            tx_temp = jf_temp.JobFile.Processing(p).Results.Displacement.Raw.X;
            
            % Get the number of frames that were processed
            num_frames = size(tx_temp, 2);
            
            % Get the index
            end_frame_idx = start_frame_idx + num_frames - 1;
            
            % Copy the results
            %
            % Translation X Raw
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Raw.X(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Raw.X;
            
            % Translation Y Raw
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Raw.Y(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Raw.Y; 
             
            % Translation X Validated
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Validated.X(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Validated.X;
            
            % Translation Y Validated
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Validated.Y(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Validated.Y; 
             
            % Translation X Smoothed
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Smoothed.X(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Smoothed.X;
            
            % Translation Y Smoothed
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Smoothed.Y(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Smoothed.Y; 
             
            % Translation X Final
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Final.X(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Final.X;
            
            % Translation Y Final
            JOBFILE_GATHERED.Processing(p). ...
                Results.Displacement.Final.Y(:, start_frame_idx : end_frame_idx) ...
                 = jf_temp.JobFile.Processing(p).Results.Displacement.Final.Y;          
            
            % Source displacements X
            JOBFILE_GATHERED.Processing(p). ...
                Iterative.Source.Displacement.X(:, start_frame_idx : end_frame_idx) = ...
                jf_temp.JobFile.Processing(p).Iterative.Source.Displacement.X;
            
            % Source displacements Y
            JOBFILE_GATHERED.Processing(p). ...
                Iterative.Source.Displacement.Y(:, start_frame_idx : end_frame_idx) = ...
                jf_temp.JobFile.Processing(p).Iterative.Source.Displacement.Y;
             
            % Source grid X
            JOBFILE_GATHERED.Processing(p).Iterative.Source.Grid.X = ...
                jf_temp.JobFile.Processing(p).Iterative.Source.Grid.X;
            
            %  Source grid Y
            JOBFILE_GATHERED.Processing(p).Iterative.Source.Grid.Y = ...
                jf_temp.JobFile.Processing(p).Iterative.Source.Grid.Y;
            
            % Get the particle sizes for filtering
            JOBFILE_GATHERED.Processing(p). ...
                Results.Filtering.Diameter.X(:, start_frame_idx : end_frame_idx) = ...
                 jf_temp.JobFile.Processing(p).Results.Filtering.Diameter.X;
             
             % Get the particle sizes for filtering
            JOBFILE_GATHERED.Processing(p). ...
                Results.Filtering.Diameter.Y(:, start_frame_idx : end_frame_idx) = ...
                 jf_temp.JobFile.Processing(p).Results.Filtering.Diameter.Y;
        end
        
        % Update the start frame index
        start_frame_idx = start_frame_idx + num_frames;
    end
    
    % Get the output path
    OUTPUT_FILE_PATH = determine_jobfile_save_path(JOBFILE_GATHERED);
    
    % Set the output path
    JOBFILE_GATHERED.Data.Outputs.Vectors.Path = OUTPUT_FILE_PATH;
    
    % Rename the jobfile
    JobFile = JOBFILE_GATHERED;
    
    % Save the gathered job.
    save(OUTPUT_FILE_PATH, 'JobFile', '-v7.3');

end






