function correlation_method_str = read_correlation_method(JOBFILE, PASS_NUMBER)

% Default to pass number 1.
if nargin < 2
    PASS_NUMBER = 1;    
end

% Read the correlation method
correlation_method_str = JOBFILE.Processing(PASS_NUMBER).Correlation.Method;


end