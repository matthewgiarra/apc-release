function [APC_FILTER, APC_STD_Y, APC_STD_X] = ...
    calculate_apc_filter_magnitude_method(SPECTRAL_CORRELATION_COMPLEX)

    % To do: Uncomment below to make calculating the APC filter optional.
    % Also change the order of the inputs to [APC_STD_Y, APC_STD_X, APC_FILTER]

    % Default to not making the filters
%     if nargin < 2
%         MAKE_FILTER = false;
%     end

    % Size of the region
    [region_height, region_width] = size(SPECTRAL_CORRELATION_COMPLEX);

    % Fit a Gaussian function to the magnitude
    % of the complex correlation, 
    % which should represent the SNR versus wavenumber.
    [~, APC_STD_Y, APC_STD_X] =...
        fit_gaussian_2D(abs(SPECTRAL_CORRELATION_COMPLEX) ...
        ./ max(abs(SPECTRAL_CORRELATION_COMPLEX(:))));
    
    
    % Make the filter if requested
%     if MAKE_FILTER

        % % Calculate the filter
        %
        % Make coordinate vectors
        xv = (1 : region_width) - fourier_zero(region_width);
        yv = (1 : region_height) - fourier_zero(region_height);

        % Make coordinate arrays
        [X, Y] = meshgrid(xv, yv);

        % Calculate filter
        APC_FILTER = exp(-X.^2 / (2 * APC_STD_X^2) - Y.^2 / (2 * APC_STD_Y^2));

%     else
%         APC_FILTER = [];
%     end
    
end