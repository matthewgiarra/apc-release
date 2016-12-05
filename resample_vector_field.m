function [U_INTERP, V_INTERP] = resample_vector_field(X, Y, U, V, XI, YI)

% I'm writing this code to resample a vector 
% field from one grid onto another grid. 
% This processes is peformed in a few places:
% deforming images, discrete window offset, 
% and also adding a previous pass' displacement
% estimates to the result of a deformed / DWO pass,
% which ideally will have subpixel values.

% Determine the number of
% points in the row and 
% column directions
% for the original grid
nx = length(unique(X(:)));
ny = length(unique(Y(:)));

% Reshape the original grid
% coordinate vectors into 2-D arrays.
x_mat = reshape(X(:), [ny, nx]);
y_mat = reshape(Y(:), [ny, nx]);

% Reshape vectors into arrays
u_mat = reshape(U(:), [ny, nx]);
v_mat = reshape(V(:), [ny, nx]);

% Create interpolation structures for the velocity field.
interpolant_tx = griddedInterpolant(y_mat, x_mat, u_mat, 'spline', 'linear');
interpolant_ty = griddedInterpolant(y_mat, x_mat, v_mat, 'spline', 'linear');

% This is the velocity field upsampled to every pixel.
u_interp_mat = interpolant_tx(YI, XI);
v_interp_mat = interpolant_ty(YI, XI);

% Reshape the arrays into vectors.
U_INTERP = u_interp_mat(:);
V_INTERP = v_interp_mat(:);

end