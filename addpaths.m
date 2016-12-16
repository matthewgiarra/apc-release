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
addpath(fullfile(ROOT, 'plotting'));
addpath(fullfile(ROOT, 'plotting', 'export_fig'));

addpath(fullfile(ROOT, 'spectral-phase-correlation'));
addpath(fullfile(ROOT, 'spectral-phase-correlation', 'phase_unwrapping'));
addpath(fullfile(ROOT, 'spectral-phase-correlation', 'phase_unwrapping', 'compile_scripts'));
addpath(fullfile(ROOT, 'spectral-phase-correlation', 'spectral_filtering'));

end