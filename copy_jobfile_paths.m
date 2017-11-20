function DstJobFile = copy_jobfile_paths(SrcJobFile, DstJobFile)

    % Load jobfiles if strings are passed
    if ischar(SrcJobFile)
        sjf = load(SrcJobFile);
        SrcJobFile = sjf.JobFile;
        clear('sjf');
    end
    
    if ischar(DstJobFile)
       djf = load(DstJobFile);
       DstJobFile = djf.JobFile;
       clear('djf');
    end

    % Copy data field
    DstJobFile.Data = SrcJobFile.Data;

    % Number of passes
    num_passes = length(DstJobFile.Processing);
    
    % Loop over all the passes
    for p = 1 : num_passes
        DstJobFile.Processing(p).Grid.Mask.Directory = ...
            SrcJobFile.Processing(1).Grid.Mask.Directory;
        
        DstJobFile.Processing(p).Frames = ...
            SrcJobFile.Processing(1).Frames;
    end

end