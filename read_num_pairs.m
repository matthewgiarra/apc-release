function num_pairs = read_num_pairs(JOBFILE, PASS_NUMBER)

% Default to pass number 1
if nargin < 2
    PASS_NUMBER = 1; 
end

% Number of pairs to correlate
num_pairs = length(JOBFILE.Processing(PASS_NUMBER).Frames.Paths{1});


end