function DISPLACEMENT_ESTIMATE_DOMAIN_STRING = ...
    get_displacement_estimate_domain(JOBFILE, PASS_NUMBER)

% Default to pass number 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Check if the displacement estimate domain field exists
if isfield(JOBFILE.Processing(PASS_NUMBER). ...
        Correlation.DisplacementEstimate, 'Domain')
    
    % Read the displacement estimate domain string from the jobfile.
    DISPLACEMENT_ESTIMATE_DOMAIN_STRING = ...
        JOBFILE.Processing(PASS_NUMBER).Correlation. ...
        DisplacementEstimate.Domain;
else
    % Default to spatial
    DISPLACEMENT_ESTIMATE_DOMAIN_STRING = 'spatial';
end

    
end