function spectral_weighting_method_str = ...
    get_spectral_weighting_method(JOBFILE, PASS_NUMBER)

% Default to pass number 1.
if nargin < 2
    PASS_NUMBER = 1;    
end

% Read the correlation method
spectral_weighting_method_str = JOBFILE.Processing(PASS_NUMBER). ...
    Correlation.SpectralWeighting.Method;


end