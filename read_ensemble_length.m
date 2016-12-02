function ensemble_length = read_ensemble_length(JOBFILE, PASS_NUMBER)

% Default to pass number of one.
if nargin < 2
    PASS_NUMBER = 1;
end

% Set the ensemble length to 1 as the default
ensemble_length = 1;

% Check if the ensemble field is present
if isfield(JOBFILE.Processing(PASS_NUMBER).Correlation, 'Ensemble')
    
    % Read the Ensemble correlation field
    ensemble_field = JOBFILE.Processing(PASS_NUMBER).Correlation.Ensemble;
    
    % Check if the "do ensemble" field is present
    if isfield(ensemble_field, 'DoEnsemble') && ...
            isfield(ensemble_field, 'NumberOfPairs');
        
        % Check that the flag for doing ensemble
        % is set to true.
        if ensemble_field.DoEnsemble == true;
            
            % Set the ensemble length ot be the 
            % value specified in the job file.
            ensemble_length = ensemble_field.NumberOfPairs;
        end
    end   
end

end