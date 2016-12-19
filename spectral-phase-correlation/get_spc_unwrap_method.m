function SPC_UNWRAP_METHOD_STRING = get_spc_unwrap_method(JOBFILE, PASS_NUMBER)

% Default to pass number 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Check existence of field
if isfield(JOBFILE.Processing(PASS_NUMBER).Correlation. ...
        DisplacementEstimate.Spectral, 'UnwrappingMethod')
    
    % Read the SPC unwrapping method
    SPC_UNWRAP_METHOD_STRING = lower(JOBFILE.Processing(PASS_NUMBER). ...
        Correlation.DisplacementEstimate.Spectral.UnwrappingMethod);
    
else
    % Default to no unwrapping
    SPC_UNWRAP_METHOD_STRING = 'ERROR';
end;


end