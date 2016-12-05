function [u_interp, v_interp] = resample_vector_field(grid_old_x, grid_old_y, ...
    vector_old_x, vector_old_y, grid_new_x, grid_new_y)

% I'm writing this code to resample a vector 
% field from one grid onto another grid. 
% This processes is peformed in a few places:
% deforming images, discrete window offset, 
% and also adding a previous pass' displacement
% estimates to the result of a deformed / DWO pass,
% which ideally will have subpixel values.

end