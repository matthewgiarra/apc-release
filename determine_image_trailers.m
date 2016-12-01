function [INPUT_IMAGE_TRAILER_01, INPUT_IMAGE_TRAILER_02] = ...
        determine_image_trailers(JOBFILE)
    
    % Extract the image field of the jobfile structure
    image_field = JOBFILE.Data.Inputs.Images;
    
    % Read the trailer field
    if ~isfield(image_field, 'Trailers')
        INPUT_IMAGE_TRAILER_01 = '';
        INPUT_IMAGE_TRAILER_02 = '';
    else
        
        % If the trailer field exists, 
        % extract it from the job file.
        trailer_field = image_field.Trailers;
        
        % If the field is empty, 
        % then return both trailers as empty.
        if isempty(trailer_field)
            INPUT_IMAGE_TRAILER_01 = '';
            INPUT_IMAGE_TRAILER_02 = '';
            
        % If only one trailer is specified,
        % then return both trailers as the same trailer.
        elseif length(trailer_field) == 1
            INPUT_IMAGE_TRAILER_01 = trailer_field{1};
            INPUT_IMAGE_TRAILER_02 = trailer_field{1};
        
        % Otherwise, return the two trailers as the
        % first two fields of the trailer field.
        else
            INPUT_IMAGE_TRAILER_01 = trailer_field{1};
            INPUT_IMAGE_TRAILER_02 = trailer_field{2};
        end
    end
    
end