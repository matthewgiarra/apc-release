function plot_piv_job_list(JOBLIST, PASS_NUMBER, VECT_TO_PLOT)

if nargin < 3
    VECT_TO_PLOT = 'final';
end

if nargin < 2
    PASS_NUMBER = 0;
end

% Set pass number to 0 if an empty argument is passed.
if isempty(PASS_NUMBER)
    PASS_NUMBER = 0;
end

plot_final = ~isempty(regexpi(VECT_TO_PLOT, 'fi'));
plot_validated = ~isempty(regexpi(VECT_TO_PLOT, 'va'));
plot_smoothed = ~isempty(regexpi(VECT_TO_PLOT, 'sm'));
plot_raw = ~isempty(regexpi(VECT_TO_PLOT, 'raw'));

% Vector scale
vect_scale = 8;

% Vector skip
skip_x = 4;
skip_y = 4;

% Count the number of jobs
num_jobs = length(JOBLIST);

% Initialize the max and min velocities.
vel_max = -inf;
vel_min = inf;

% Loop over the jobs
for n = 1 : num_jobs
    
    % Extract the job file
    JobFile = JOBLIST(n);
    
    % Determine the save path
    output_file_path = determine_jobfile_save_path(JobFile);
    
    % File name
    [~, file_name, ~] = fileparts(output_file_path);
    
    % File name for the plots
    file_name_plot = strrep(file_name, '_', '\_');
    
    % Load the output file
    loaded_jobfile = load(output_file_path);
    
    % Loaded job file
    JobFile_Loaded = loaded_jobfile.JobFile;
    
    % Measure the number of passes
    num_passes = length(JobFile_Loaded.Processing);
    
    % Figure out which pass to plot
    if PASS_NUMBER == 0
        pass_to_plot = num_passes;
    else
        % Figure out which pass to plot
        pass_to_plot = min(PASS_NUMBER, num_passes);
    end
        
    % Determine which displacement field to plot
    if plot_raw
        displacement_field = JobFile_Loaded.Processing(pass_to_plot).Results.Displacement.Raw;
    elseif plot_validated
        displacement_field = JobFile_Loaded.Processing(pass_to_plot).Results.Displacement.Validated;
    elseif plot_smoothed
        displacement_field = JobFile_Loaded.Processing(pass_to_plot).Results.Displacement.Smoothed;
    elseif plot_final
        displacement_field = JobFile_Loaded.Processing(pass_to_plot).Results.Displacement.Final;
    end

    % Read the displacement field
    tx = displacement_field.X(:, 1);
    ty = displacement_field.Y(:, 1);
    
    % Read the grid points.
    gx = JobFile_Loaded.Processing(pass_to_plot).Grid.Points.Full.X;
    gy = JobFile_Loaded.Processing(pass_to_plot).Grid.Points.Full.Y;
    
    % Count the grid points
    nx = length(unique(gx(:)));
    ny = length(unique(gy(:)));
    
    % Reshape grid
    gx_mat = reshape(gx, [ny, nx]);
    gy_mat = reshape(gy, [ny, nx]);
    
    % Reshape vectors
    tx_mat = reshape(tx, [ny, nx]);
    ty_mat = reshape(ty, [ny, nx]);
    
    % Create a figure
    subplot(2, 3, n);
    imagesc(gx, gy, tx_mat);
    axis image;
    hold on;
    quiver(             gx_mat(1 : skip_y : end, 1 : skip_x : end), ...
                        gy_mat(1 : skip_y : end, 1 : skip_x : end), ...
           vect_scale * tx_mat(1 : skip_y : end, 1 : skip_x : end), ...
           vect_scale * ty_mat(1 : skip_y : end, 1 : skip_x : end), ...
           0, '-k', 'linewidth', 1.5);

    % Load the mask
    grid_mask = load_mask(JobFile, num_passes);
    [mask_points_y, mask_points_x] = get_mask_outline(grid_mask);
    
    % Plot the mask points.
    plot(mask_points_x, mask_points_y, 'ok');
    hold off;
    
    % Title
    title(file_name_plot, 'fontsize', 20);
    
    % Calculate the max and min velocities
    % of all the plotted data.
    vel_max = max(vel_max, max(tx(:)));
    vel_min = min(vel_min, min(tx(:)));

    % Set the color scale
    caxis([vel_min, vel_max]);
    
    % Image size
    [image_height, ~] = read_image_size(JobFile);
    
    % Set the horizontal plot limits
    xlim([min(gx(:)), max(gx(:))]);
    ylim([1, image_height]);
      
end

% Tile the figures


end


