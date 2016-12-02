function JOBFILE = discrete_window_offset(JOBFILE, PASS_NUMBER)

% % % % INCOMPLETE CODE % % % % % % 


% Default to pass number 1.
if nargin < 2
   PASS_NUMBER = 1; 
end

% Read the name of the iterative method from the job file.
iterative_method = JOBFILE.Processing(PASS_NUMBER).Iterative.Method;

% Check whether discrete window offset (DWO) is specified
do_dwo = ~isempty(regexpi(iterative_method, 'dwo'));

% If DWO is specified, then perform DWO.
if do_dwo
    
    % Create DWO parameters structure
    dwo_parameters = {};
    
    % Read the image size
    [image_height, image_width] = read_image_size(JOBFILE, PASS_NUMBER);
    
    % Populate DWO parameters
    % Image size
    dwo_parameters.Images.Height = image_height;
    dwo_parameters.Images.Width = image_width;
    %
    % Grid parameters
    dwo_parameters.Grid = JOBFILE.Processing(PASS_NUMBER).Grid;
    
    % Read the source grid.
    grid_source_x = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.X;
    grid_source_y = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.Y;
    
    % Read the source displacement field
    source_field_tx = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.X;
    source_field_ty = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.Y;
    
    % Read the new unshifted grid
    grid_new_unshifted_x = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X;
    grid_new_unshifted_y = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.Y;
    
    [x_grid_01, y_grid_01, ...
     x_grid_02, y_grid_02] = ...
    discrete_window_offset_sub_function(...
    grid_new_unshifted_x, grid_new_unshifted_y, grid_source_x, grid_source_y, source_field_tx, source_field_ty); 

end
    
    

end


function [...
    x_grid_01, y_grid_01, ...
    x_grid_02, y_grid_02] = ...
    discrete_window_offset_sub_function(...
    grid_new_unshifted_x, grid_new_unshifted_y, ...
    grid_source_x, grid_source_y, ...
    source_field_tx, source_field_ty) 
% Inputs: 
%   XGRID and YGRID are the matrices or vectors of the column and row 
%   grid points prior to shifting. These Should be in the format of meshgrid.
% 
%   U and V are the velocity fields by which to shift the grid points.
%   The size of U and V need not be the same as the size of XGRID and
%   YGRID. If the sizes of U and V are equal to the sizes of XGRID and
%   YGRID, then the grid will be shifted by exactly U and V; if those
%   sizes are not equal, then the shifts applied to XGRID and YGRID 
%   will be interpolated (linear) from U and V.  
%
% OUTPUTS
%   X_GRID_01 and Y_GRID_01 are the shifted grids for the first image in
%   the pair.
%   
%   X_GRID_02 and Y_GRID_02 are the shifted grids for the second image in
%   the pair.
%   

% Interpolate the shift-field onto the input grid. U and V are the
% non-integer horizontal and vertical displacements by whose rounded values
% the grid is shifted.
% The first  "linear" is the interpolation method and
% The second "linear" is the extrapolation method.
% We are using scatteredInterpolant because interp2 doesn't have a
% good extrapolation method input. 
interpolant_U = scatteredInterpolant(grid_source_y(:), ...
    grid_source_x(:), source_field_tx(:), 'linear','linear');

interpolant_V = scatteredInterpolant(grid_source_y(:),grid_source_x(:), ...
    source_field_ty(:), 'linear','linear');

% Figure out the shifts
gridShiftX = interpolant_U(grid_new_unshifted_y, grid_new_unshifted_x);
gridShiftY = interpolant_V(grid_new_unshifted_y, grid_new_unshifted_x);

% Shift the grid points from the first image by -1/2 times the input
% displacement field.
x_grid_01 = grid_new_unshifted_x - round(1/2 * gridShiftX);
y_grid_01 = grid_new_unshifted_y - round(1/2 * gridShiftY);

% Shift the grid points from the second image by +1/2 times the input
% displacement field
x_grid_02 = grid_new_unshifted_x + round(1/2 * gridShiftX);
y_grid_02 = grid_new_unshifted_y + round(1/2 * gridShiftY);


end
