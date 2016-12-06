function plot_piv_job_list(JOBLIST)

% Vector scale
vect_scale = 4;

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
    load(output_file_path);
    
    % Only plot the raw, unsmoothed fields.
    tx = JobFile.Processing(end).Results.Displacement.Raw.X(:, 1);
    ty = JobFile.Processing(end).Results.Displacement.Raw.Y(:, 1);
    
    % Set zeros to nans for plotting.
    tx(tx == 0) = nan;
    ty(ty == 0) = nan;
    
    % Measure the number of passes
    num_passes = length(JobFile.Processing);
    
    % Extract the grid
    gx = JobFile.Processing(num_passes).Grid.Points.Full.X;
    gy = JobFile.Processing(num_passes).Grid.Points.Full.Y;
    
    % Count the grid points
    nx = length(unique(gx(:)));
    ny = length(unique(gy(:)));
    
    % Reshape vectors
    tx_mat = reshape(tx, [ny, nx]);
    
    % Create a figure
    figure(n);
    imagesc(gx, gy, tx_mat);
    axis image;
    hold on;
    quiver(gx, gy, vect_scale * tx, vect_scale * ty, 0, '-k', 'linewidth', 1.5);

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
tilefigs;

end


