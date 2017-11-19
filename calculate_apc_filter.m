function [APC_FILTER, APC_STD_Y, APC_STD_X] = ...
    calculate_apc_filter(SPECTRAL_CORRELATION_COMPLEX, RPC_DIAMETER, METHOD)
% This function calculates the APC filter 
% from either the magnitude or the phase of the correlation.

% Default to magnitude-based APC
% if no method is specified
if nargin < 3
    METHOD = 'magnitude';
end

% Default to magnitude-based APC
% if an empty string is passed.
if isempty(METHOD)
    METHOD = 'magnitude';
end

% Default to no lower limit on the RPC diameger
if nargin < 2
    RPC_DIAMETER = 0;
end

% Pick between APC methods
switch lower(METHOD)
    case 'magnitude'
        % Magnitude-based APC filter calculation
        % This is Matt Giarra's method that
        % his paper talks about. 
        [APC_FILTER, APC_STD_Y, APC_STD_X] = ...
            calculate_apc_filter_magnitude_method(SPECTRAL_CORRELATION_COMPLEX, RPC_DIAMETER);
        
        % Phase-quality based APC filter calculation
    case 'phase'
        [APC_FILTER, APC_STD_Y, APC_STD_X] = ...
    calculate_apc_filter_phase_method(SPECTRAL_CORRELATION_COMPLEX, ...
    RPC_DIAMETER);

    otherwise
        
        % Throw an error if an invalid method was specified.
        error(...
            ['Error: invalid APC method ("%s") specified.' , ...
            '\nUse either "phase" or "magnitude".\n'], lower(METHOD));
end
    
end