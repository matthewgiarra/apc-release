function addpaths(ROOT)
% Root is the top level directory containing all
% the other code directories

% Get the path to the user's desktop
if nargin < 1
    ROOT = '.';
end

% Add the paths
addpath(fullfile(ROOT, 'jobfiles'));
addpath(fullfile(ROOT, 'scripts'));
addpath(fullfile(ROOT, 'apc_phase_quality_method'));

end