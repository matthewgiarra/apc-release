function plot_time_resolved_fields(JOBFILE)

% Results path 
results_path = determine_jobfile_save_path(JOBFILE);

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

temporal_ensemble = ~isempty(regexpi(JobFile(1).Processing.Correlation.Ensemble.Direction, 'tem'));

if temporal_ensemble
    num_pairs = 1;
end

% Loop over all the data
for n = 1 : num_pairs
    
    for p = 1 : num_passes
       
        gx = JobFile.Processing(p).Grid.Points.Full.X;
        gy = JobFile.Processing(p).Grid.Points.Full.Y;
        
        tx = JobFile.Processing(p).Results.Displacement.Raw.X(:, n);
        ty = JobFile.Processing(p).Results.Displacement.Raw.Y(:, n);
        
        dp_x = JobFile.Processing(p).Results.Filtering.APC.Diameter.X(:, n);
        dp_y = JobFile.Processing(p).Results.Filtering.APC.Diameter.Y(:, n);
        
        % Reshapes
        nx = length(unique(gx));
        ny = length(unique(gy));
        gx_mat = reshape(gx, [ny, nx]);
        gy_mat = reshape(gy, [ny, nx]);
        tx_mat = reshape(tx, [ny, nx]);
        ty_mat = reshape(ty, [ny, nx]);
        dp_x_mat = reshape(dp_x, [ny, nx]);
        dp_y_mat = reshape(dp_y, [ny, nx]);
        
        % Averages
        dp_x_mean = mean(dp_x_mat, 2);
        dp_y_mean = mean(dp_y_mat, 2);
        tx_mean = mean(tx_mat, 2);
        ty_mean = mean(ty_mat, 2);
        
  
        % Make the plot
        subtightplot(1, num_passes, p);
        imagesc(gx_mat(:), gy_mat(:), dp_x_mat);
        hold on;
        quiver(gx_mat(1 : skip_y : end, 1 : skip_x : end), ...
               gy_mat(1 : skip_y : end, 1 : skip_x : end), ...
               vector_scale * tx_mat(1 : skip_y : end, 1 : skip_x : end), ...
               vector_scale * ty_mat(1 : skip_y : end, 1 : skip_x : end), ...
               0, 'white');
           
       hold off
        axis image; 
        xlim([1, image_width]);
        ylim([1, image_height]);
    end
  
    drawnow;
    
end



end

