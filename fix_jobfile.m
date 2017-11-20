for k = 1 : length(JobFile.Processing)
    sx = JobFile.Processing(k).Results.Filtering.APC.Diameter.Raw.X;
    JobFile.Processing(k).Results.Filtering.APC.Diameter.X = sx;
    
    JobFile.Processing(k).Results.Filtering.APC.Diameter = ...
        rmfield(JobFile.Processing(k).Results.Filtering.APC.Diameter, 'Raw');
end
   