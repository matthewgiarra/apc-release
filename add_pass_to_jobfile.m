function JobFile = add_pass_to_jobfile(JobFile, source_jobfile, source_pass)

    % Default to taking the last pass of the source jobfile.
    if nargin < 3
        source_pass = length(source_jobfile.Processing);
    end
    
    if ischar(source_jobfile)
        sjob = load(source_jobfile);
        source_jobfile = sjob.JobFile;
    end
    
    if ischar(JobFile)
        jf = load(JobFile);
        JobFile = jf.JobFile;
    end


    JobFile.Processing(end + 1) = JobFile.Processing(end);
    
    % Region
    JobFile.Processing(end).Region = ...
        source_jobfile.Processing(source_pass).Region;
    
    % Window
    JobFile.Processing(end).Window = ...
        source_jobfile.Processing(source_pass).Window;
    
    % Grid
    JobFile.Processing(end).Grid = ...
        source_jobfile.Processing(source_pass).Grid;
    
    % Frames
    JobFile.Processing(end).Frames = ...
        source_jobfile.Processing(source_pass).Frames;
    
    % Correlation
    JobFile.Processing(end).Correlation = ...
        source_jobfile.Processing(source_pass).Correlation;
    
    % Subpixel
    JobFile.Processing(end).SubPixel = ...
        source_jobfile.Processing(source_pass).SubPixel;
    
    % Smoothing
    JobFile.Processing(end).Smoothing = ...
        source_jobfile.Processing(source_pass).Smoothing;
    
    % Iterative
    JobFile.Processing(end).Iterative = ...
        source_jobfile.Processing(source_pass).Iterative;

    % Update data
    JobFile.Data = source_jobfile.Data;
    
    % Update options
    JobFile.JobOptions = source_jobfile.JobOptions;
    
    % Check displacement vector arrays are the right size
    first_image = JobFile.Processing(end-1).Frames.Start;
    end_image = JobFile.Processing(end-1).Frames.End;
    step_image = JobFile.Processing(end-1).Frames.Step;
    
    % Image numbers
    image_nums = first_image : step_image : end_image;
    
    % Number of images
    num_images = length(image_nums);
    
    % Check the size of the displacement vector
    tx_source = JobFile.Processing(end-1).Results.Displacement.Final.X;
    ty_source = JobFile.Processing(end-1).Results.Displacement.Final.X;
    
    if (size(tx_source, 2) == 1 && num_images > 1)
        tx_rep = repmat(tx_source, [1, num_images]);
        JobFile.Processing(end - 1).Results.Displacement.Final.X = tx_rep;
    end
    
    if (size(ty_source, 2) == 1 && num_images > 1)
        ty_rep = repmat(ty_source, [1, num_images]);
        JobFile.Processing(end - 1).Results.Displacement.Final.Y = ty_rep;
    end
  
   
end


