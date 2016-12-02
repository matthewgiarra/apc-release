function grid_mask = load_mask(JOBFILE, PASS_NUMBER)

% Default to pass 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Check if a mask was specified
grid_field = JOBFILE.Processing(PASS_NUMBER).Grid;

% Create an empty mask (set to ones everywhere)
% Measure the image size and set the mask to ones.
[image_height, image_width] = read_image_size(JOBFILE, PASS_NUMBER);

% Set the mask to ones everywhere
grid_mask = ones(image_height, image_width);

% Check that the mask field was specified in the job file.
if isfield(grid_field, 'Mask');
    
    % Check if the directory or name are empty strings
    mask_dir = JOBFILE.Processing(PASS_NUMBER).Grid.Mask.Directory;
    mask_name = JOBFILE.Processing(PASS_NUMBER).Grid.Mask.Name;
    
    % If both the mask directory
    % and the mask name fields contain
    % strings, then use use those strings
    % to construct a file name, which
    % should point to the file that specifies the mask.
    if ~isempty(mask_dir) && ~isempty(mask_name)
        
        % Construct a path to the mask
        mask_path = fullfile(mask_dir, mask_name);
        
        % Check that the mask exists
        if exist(mask_path, 'file');  
            
            % Load the mask file.
            grid_mask = double(imread(mask_path));
            
        else
            
            % Throw an error if the mask wasn't found
            fprintf(1, 'ERROR: Mask file not found:\n%s', mask_path);
            fprintf(1, 'Setting grid to UNMASKED.\n');
        
        end
    end
end

end