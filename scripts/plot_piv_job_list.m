function plot_piv_job_list(JOBLIST)

% Vector scale
vect_scale = 2;

% Count the number of jobs
num_jobs = length(JOBLIST);

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
    
    % Extract the grid
    gx = JobFile.Processing(end).Grid.Points.Full.X;
    gy = JobFile.Processing(end).Grid.Points.Full.Y;
    
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
    quiver(gx, gy, vect_scale * tx, vect_scale * ty, 0, '-k', 'linewidth', 2);
    hold off;
    
    % Title
    title(file_name_plot, 'fontsize', 20);
    
    if n == 1
        ca = caxis;
    else
        caxis(ca)
    end
   
end

% Tile the figures
tilefigs;

end


