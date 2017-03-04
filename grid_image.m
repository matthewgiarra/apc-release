function JOBFILE = grid_image(JOBFILE, PASS_NUMBER);

% Default to pass number 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Get the image size.
[image_height, image_width] = read_image_size(JOBFILE, PASS_NUMBER);

% Vector containing the image size
image_size = [image_height, image_width];

% Grid spacing
grid_spacing_y = JOBFILE.Processing(PASS_NUMBER).Grid.Spacing.Y;
grid_spacing_x = JOBFILE.Processing(PASS_NUMBER).Grid.Spacing.X;
grid_spacing = [grid_spacing_y, grid_spacing_x];

% Grid buffer
grid_buffer_y = JOBFILE.Processing(PASS_NUMBER).Grid.Buffer.Y;
grid_buffer_x = JOBFILE.Processing(PASS_NUMBER).Grid.Buffer.X;

% Grid shift
grid_shift_y = JOBFILE.Processing(PASS_NUMBER).Grid.Shift.Y;
grid_shift_x = JOBFILE.Processing(PASS_NUMBER).Grid.Shift.X;

% Full grid
[grid_full_x, grid_full_y] = grid_image_subfunction(image_size, grid_spacing,...
    grid_buffer_y, grid_buffer_x, grid_shift_y, grid_shift_x);

% Image indices specified by the grid
grid_inds = sub2ind([image_height, image_width], grid_full_y, grid_full_x);

% Load the mask for the pass number
grid_mask = load_mask(JOBFILE, PASS_NUMBER);

% Indices to correlate
grid_correlate_inds = find(grid_mask(grid_inds) > 0);

% Grid points to correlate
grid_correlate_x = grid_full_x(grid_correlate_inds);
grid_correlate_y = grid_full_y(grid_correlate_inds);

% Add the grid points to the job file.
JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X = grid_full_x;
JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.Y = grid_full_y;
JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.X = grid_correlate_x;
JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.Y = grid_correlate_y;
JOBFILE.Processing(PASS_NUMBER).Grid.Points.Correlate.Indices = grid_correlate_inds;

end











