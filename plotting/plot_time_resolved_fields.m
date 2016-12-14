
% Specify results path
results_path = ...
    '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/vect/test/A_deghost_00001_00005.mat';

% Load the results
load(results_path);

% Choose the pass
pass_number = 1;

% Count the number of fields
num_pairs = read_num_pairs(JobFile);

% number of passes
num_passes = determine_number_of_passes(JobFile);

% Vector scale
vector_scale = 3;

% Skips
skip_x = 1;
skip_y = 1;

% Measure the image size
[image_height, image_width] = read_image_size(JobFile);

% Loop over all the data
for n = 1 : num_pairs
    
    for p = 1 : num_passes
       
        gx = JobFile.Processing(p).Grid.Points.Full.X;
        gy = JobFile.Processing(p).Grid.Points.Full.Y;
        
        tx = JobFile.Processing(p).Results.Displacement.Raw.X(:, n);
        ty = JobFile.Processing(p).Results.Displacement.Raw.Y(:, n);
        
        % Reshapes
        nx = length(unique(gx));
        ny = length(unique(gy));
        gx_mat = reshape(gx, [ny, nx]);
        gy_mat = reshape(gy, [ny, nx]);
        tx_mat = reshape(tx, [ny, nx]);
        ty_mat = reshape(ty, [ny, nx]);
  
        % Make the plot
        subtightplot(1, num_passes, p);
        quiver(gx_mat(1 : skip_y : end, 1 : skip_x : end), ...
               gy_mat(1 : skip_y : end, 1 : skip_x : end), ...
               vector_scale * tx_mat(1 : skip_y : end, 1 : skip_x : end), ...
               vector_scale * ty_mat(1 : skip_y : end, 1 : skip_x : end), ...
               0, 'black');
           axis image;
           
        xlim([1, image_width]);
        ylim([1, image_height]);
    end
  
    pause(0.5);
    
end

