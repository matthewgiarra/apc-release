function ensemble_domain_string = read_ensemble_domain(JOBFILE, PASS_NUMBER);

% Default to pass number of 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Read the ensemble domain
ensemble_domain_string = ...
    lower(JOBFILE.Processing(PASS_NUMBER).Correlation.Ensemble.Domain);

end