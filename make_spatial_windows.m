function [WINDOW_01, WINDOW_02] = ...
        make_spatial_windows(JOBFILE, PASS_NUMBER);
    
    % Default to pass 1
    if nargin < 2
        PASS_NUMBER = 1;
    end
    
    % Parameters
    parameters = JOBFILE.Processing(PASS_NUMBER);

    % Region sizes
    region_height = parameters.Region.Height;
    region_width  = parameters.Region.Width;

    % Window fraction
    window_fraction_field = parameters.Window.Fraction;
    
    % If the window fraction data type
    % is a cell, then the possibility
    % exists that uneven windowing was 
    % specified. Check to see
    % whether this is the case.
    if iscell(window_fraction_field)
        num_fractions_specified = length(window_fraction_field);
        
        % Read the first window fraction
        window_fraction_01 = window_fraction_field{1};
        
        % Determine whether separate fractions were specified
        if num_fractions_specified > 1
            window_fraction_02 = window_fraction_field{2};
        else
            window_fraction_02 = window_fraction_01;
        end
        
    else
        
        % Number of window fractions specified
        num_fractions_specified = size(window_fraction_field, 1);
        
        % Read the first window size.
        window_fraction_01 = window_fraction_field(1, :);
        
        % If a different size is specified for
        % the second window, then read it. 
        if num_fractions_specified > 1
            window_fraction_02 = window_fraction_field(2, :);
        else
            window_fraction_02 = window_fraction_01;
        end
        
    end
    
    % Make the first window
    WINDOW_01 = gaussianWindowFilter(...
        [region_height, region_width], ...
        window_fraction_01, ...
        'fraction');
    
    % Make the second window
    WINDOW_02 = gaussianWindowFilter(...
        [region_height, region_width], ...
        window_fraction_02, ...
        'fraction');
  
end
    
   