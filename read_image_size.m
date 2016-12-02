function [image_height, image_width] = read_image_size(JOBFILE, PASS_NUMBER)

    % Default to pass number of 1
    if nargin < 2
        PASS_NUMBER = 1;
    end

    % Read the field
    frames_field = JOBFILE.Processing(PASS_NUMBER).Frames;
    
    % Initialize the height and width as nans
    image_height = nan;
    image_width = nan;
    
    % Check to see if the fields exist.
    if isfield(frames_field, 'Height') && isfield(frames_field, 'Width')
        
        % Check to see if the fields are empty.
        if ~isempty(frames_field.Height) && ~isempty(frames_field.Width)
            
            % IF the fields exist and
            % they aren't empty, then just
            % copy their values into the output
            % variables of this function.
            image_height = frames_field.Height;
            image_width = frames_field.Width;
        end 
    end

    % If the image height and width weren't set,
    % then they the data weren't found in the job file.
    % This means the height and the width
    % need to be measured from the files.
    if isnan(image_height) || isnan(image_width)
        JOBFILE = measure_image_size(JOBFILE, PASS_NUMBER);
        [image_height, image_width] = read_image_size(JOBFILE, PASS_NUMBER);
    end


end