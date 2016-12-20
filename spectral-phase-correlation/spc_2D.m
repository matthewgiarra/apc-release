function [TY, TX] = spc_2D(CROSS_CORRELATION_COMPLEX, WEIGHTING_MATRIX, ...
    UNWRAP_METHOD, COMPILED)

% Default to not running compiled codes.
if nargin < 4
    COMPILED = 0;
end

% Exctract the phase of the cross correlation 
phase_plane_wrapped = split_complex(CROSS_CORRELATION_COMPLEX);

% Wrapped phase angle
phase_angle_wrapped = angle(phase_plane_wrapped);

% Unwrap using the chosen unwrapping method
% Other methods can be added.
switch lower(UNWRAP_METHOD)
    case 'herraez'
        
        % Unwrap the phase plane using the Herraez method.
        phase_plane_unwrapped = unwrap_phase_herraez(phase_angle_wrapped);
    
    case 'goldstein'
        
        % Set the maximum radius of the branch cut search box.
        max_box_size = 9;
        
        % Unwrap the phase plane using the Goldstein method.
        [phase_plane_unwrapped, branch_cut_matrix] = ...
            GoldsteinUnwrap2D(phase_angle_wrapped, ...
            max_box_size, COMPILED);
    
        % Update the weighting matrix
        WEIGHTING_MATRIX(branch_cut_matrix > 0) = 0;
        WEIGHTING_MATRIX(phase_plane_unwrapped == 0) = 0;
        
    case 'none'
        phase_plane_unwrapped = angle(phase_plane_wrapped);
        
    otherwise
        error('Error: invalid phase unwrapping algorithm specified: %s\n', ...
            UWNRAP_METHOD);
end

% Fit a plane to the unwrapped phase
[TY, TX] = spc_plane_fit(phase_plane_unwrapped, WEIGHTING_MATRIX);


end