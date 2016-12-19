function ensemble_domain_string = get_ensemble_domain(JOBFILE, PASS_NUMBER);

% Default to pass number of 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Processing field
proc_field = JOBFILE.Processing(PASS_NUMBER).Correlation;

% Default to ensemble domain as "none"
ensemble_domain_string = 'none';

% Check if the ensemble field exists.
if isfield(proc_field, 'Ensemble')
   
    % Extract the ensemble field.
    ensemble_field = proc_field.Ensemble;
    
    % Check if the "Domain" field is specified.
    % If not, default to spatial.
    if isfield(ensemble_field, 'Domain');
       
        % Read the field.
        ensemble_domain_string = lower(ensemble_field.Domain);
    end
end

end