function JOBFILE = run_scc_correlation_pass(JOBFILE, PASS_NUMBER)

% Default to pass number one
if nargin < 2
    PASS_NUMBER = 1; 
end


% Get the ensmeble length
% This will return 1 if 
% ensemble shouldn't be run.
ensemble_length = read_ensemble_length(JOBFILE, PASS_NUMBER);

% Number of pairs to correlate
num_pairs_correlate = ...
    length(JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.X);

% Region sizes
[region_height, region_width] = get_region_size(JOBFILE, PASS_NUMBER)


% Loop over all the images
for n = 1 : num_pairs_correlate
    
    
    
end



end













