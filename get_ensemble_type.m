function ensemble_domain_string = get_ensemble_type(JOBFILE, PASS_NUMBER)

% Default to pass number of 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Default to "no ensemble"
ensemble_domain_string = 'none';

% Check if the fields exist.
if isfield(JOBFILE.Processing(PASS_NUMBER).Correlation, 'Ensemble')
    
    % Extract the ensemble field
    ensemble_field = JOBFILE.Processing(PASS_NUMBER).Correlation.Ensemble;
    
    % Check if the "Type" field is specified.
    if isfield(ensemble_field, 'Type')
        
        % If the field exists, make sure it doesn't 
        % contain an emptry string.
        if ~isempty(ensemble_field.Type)
            % Read the ensemble domain
            ensemble_domain_string = ...
                lower(JOBFILE.Processing(PASS_NUMBER).Correlation.Ensemble.Type);
        end
    end
end


end