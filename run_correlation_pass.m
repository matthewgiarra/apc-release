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
% % Note that right now, this won't do ANYTHING
% which is OK because I don't need DWO at this second.
JOBFILE = discrete_window_offset(JOBFILE, PASS_NUMBER);

% Allocate the results
JOBFILE = allocate_results(JOBFILE, PASS_NUMBER);

% Check the correlation method
correlation_method = lower(read_correlation_method(JOBFILE, PASS_NUMBER));

% Pick between correlation methods
switch lower(correlation_method)
    case 'scc';
        
        % Run the SCC pass
        JOBFILE = run_scc_correlation_pass(JOBFILE, PASS_NUMBER);
    case 'rpc';
    case 'apc';
    case 'spc';
    case 'gcc';
end




end






























