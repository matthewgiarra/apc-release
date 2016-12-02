function JOBFILE = run_correlation_pass(JOBFILE, PASS_NUMBER);

% Assume pass number 1
if nargin < 2
    PASS_NUMBER = 1; 
end

% Get the source field for any iterative methods
% This should run even if no iterative method was specified
JOBFILE = get_iterative_source_field(JOBFILE, PASS_NUMBER);

% Deform the grid if requested
% This will run even if DWO isn't specified
JOBFILE = discrete_window_offset(JOBFILE, PASS_NUMBER);
    
end

