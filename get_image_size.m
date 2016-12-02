function JOBFILE = get_image_size(JOBFILE, PASS_NUMBER);

% Default to first pass.
if nargin < 2
    PASS_NUMBER = 1;
end

% Set "image found" flag to false
frame_found = false;

% Create the list of images if it doesn't already exist
if ~isfield(JOBFILE.Processing(PASS_NUMBER).Frames, 'Paths')
     JOBFILE = create_image_pair_path_list(JOBFILE, PASS_NUMBER);
end

% Frames field
paths_field = JOBFILE.Processing(PASS_NUMBER).Frames.Paths;

% Number of frames specified
num_frames = length(paths_field{1});

% Frame search counter
frame_search_counter = 0;


% Loop over the list of frames
% This whole loop should complete
% with frame_found == 0 if no frames were found
% and frame_found == 1 if a frame was found. 
% If frame_found == 1, then the value
% of frame_search_counter should be the first frame found
% in the list of frames.
while frame_search_counter <= num_frames && frame_found == 0
  
    % Increment the frame search counter
    frame_search_counter = frame_search_counter + 1;
    
    % Frame path 
    frame_path = paths_field{1}{frame_search_counter};

    % If the frame is found, then break the search loop.
    if exist(frame_path, 'file')
        frame_found = true;
    end
end

% Load the frame if it was foudn
if frame_found == true
    [image_height, image_width, ~] = size(double(imread(paths_field{1}{frame_search_counter})));
end

% Append the image size to the job file.
JOBFILE.Processing(PASS_NUMBER).Frames.Height = image_height;
JOBFILE.Processing(PASS_NUMBER).Frames.Width= image_width;

end


