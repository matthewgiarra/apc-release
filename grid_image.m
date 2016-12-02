function JOBFILE = grid_image(JOBFILE, PASS_NUMBER);

% Default to pass number 1
if nargin < 2
    PASS_NUMBER = 1;
end

% Get the image size.
[image_height, image_width] = get_image_size(JOBFILE, PASS_NUMBER);

% Vector containing the image size
image_size = [image_height, image_width];

grid_spacing_y = JOBFILE.Processing(PASS_NUMBER).Grid.Spacing.Y;
grid_spacing_x = JOBFILE.Processing(PASS_NUMBER).Grid.Spacing.X;
grid_spacing = [grid_spacing_y, grid_spacing_x];

grid_buffer_y = JOBFILE.Processing(PASS_NUMBER).Grid.Buffer.Y;
grid_buffer_x = JOBFILE.Processing(PASS_NUMBER).Grid.Buffer.X;

grid_shift_y = JOBFILE.Processing(PASS_NUMBER).Grid.Shift.Y;
grid_shift_x = JOBFILE.Processing(PASS_NUMBER).Grid.Shift.X;

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


function [X, Y] = grid_image_subfunction(...
    IMAGESIZE, GRID_SPACING, ...
    GRID_BUFFER_Y, GRID_BUFFER_X, ...
    GRID_SHIFT_Y, GRID_SHIFT_X, MASK);

% Default to no mask
if nargin < 7 || isempty(MASK)
    MASK = ones(IMAGESIZE);
elseif isempty(MASK)
    MASK = ones(IMAGESIZE);
end

% Default to no grid shift
if nargin < 6
    GRID_SHIFT_X = 0;
end
if nargin < 5
    GRID_SHIFT_Y = 0;
end
 
% Default to no grid buffer
if nargin < 4 || isempty(GRID_BUFFER_X);
    GRID_BUFFER_X = [ 0 0 ];
end

% Grid buffers
if nargin < 3 || isempty(GRID_BUFFER_Y);
    GRID_BUFFER_Y = [ 0 0 ];
end

% If only one value for grid buffer is input,
% then assume a symmetric grid buffer
if length(GRID_BUFFER_X) == 1
    GRID_BUFFER_X = GRID_BUFFER_X * [1, 1];
end
if length(GRID_BUFFER_Y) == 1
    GRID_BUFFER_Y = GRID_BUFFER_Y * [1, 1];
end

% If only one value for grid spacing is input,
% then assume a symmetric grid spacing.
if length(GRID_SPACING) == 1
    GRID_SPACING = GRID_SPACING * [1, 1];
end

% Image height and width
image_height = IMAGESIZE(1);
image_width = IMAGESIZE(2);

% Left and right horizontal grid buffers.
grid_buffer_x_left = GRID_BUFFER_X(1);
grid_buffer_x_right = GRID_BUFFER_X(2);

% Top and bottom vertical grid buffers.
grid_buffer_y_top = GRID_BUFFER_Y(1);
grid_buffer_y_bottom = GRID_BUFFER_Y(2);

% Min and max x coordinates
xmin = max([1, grid_buffer_x_left]);
xmax = min([image_width, image_width - grid_buffer_x_right]);

% Min and max y coordinates
ymin = max([1, grid_buffer_y_top]);
ymax = min([image_height, image_height - grid_buffer_y_bottom]);

% Grid spacing in x and y directions
dx = max(1, GRID_SPACING(2));
dy = max(1, GRID_SPACING(1));

% X and Y coordinate vectors
xgv = (xmin : dx : xmax) + GRID_SHIFT_X;
ygv = (ymin : dy : ymax) + GRID_SHIFT_Y;

% Grid as matrices
[xmat, ymat] = meshgrid(xgv, ygv);

% Grids as vectors
xv = xmat(:);
yv = ymat(:);

% Only take values that are inside the image
xv_inside = xv(...
               xv >= grid_buffer_x_left & ...
               xv <= (image_width - grid_buffer_x_right) & ...
               yv >= grid_buffer_y_top & ...
               yv <= (image_height - grid_buffer_y_bottom));
% Only take values that are inside the image
yv_inside = yv(...
               xv >= grid_buffer_x_left & ...
               xv <= (image_width - grid_buffer_x_right) & ...
               yv >= grid_buffer_y_top & ...
               yv <= (image_height - grid_buffer_y_bottom));
           
% Linear indices of the grid
full_inds = sub2ind([image_height, image_width], yv_inside, xv_inside);

% Values of the mask
mask_vals = MASK(full_inds);

% Nonzero parts of the mask
inds = find(mask_vals ~= 0);

% The unmaxked coordinates.
X = xv_inside(inds);
Y = yv_inside(inds);

end










