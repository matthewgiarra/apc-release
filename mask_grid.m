function [grid_x_correlate, grid_y_correlate, correlate_inds] = mask_grid(JOBFILE, PASS_NUMBER)

% Load the mask for the pass number
grid_mask = load_mask(JOBFILE, PASS_NUMBER);

% Grid the image
[grid_x, grid_y] = gridImage(JOBFILE, PASS_NUMBER);

% Get the image size
[image_height, image_width] = get_image_size(JOBFILE, PASS_NUMBER);

% Image indices specified by the grid
grid_inds = sub2ind([image_height, image_width], grid_y, grid_x);

% Indices to correlate
correlate_inds = find(grid_mask(grid_inds) > 0);

% Grid points to correlate
grid_x_correlate = grid_x(correlate_inds);
grid_y_correlate = grid_y(correlate_inds);

end