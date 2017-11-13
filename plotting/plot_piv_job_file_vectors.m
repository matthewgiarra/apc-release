
% Specify the job file to plot


job_file_dir = '/Users/matthewgiarra/Desktop/piv_test_images/pivchallenge/2014/A/vect/test/';
% job_file_name = 'A_deghost_from_source_00001_00001.mat';
job_file_name_rpc = 'A_raw_from_source_rpc_00001_00001.mat';
job_file_name_apc = 'A_raw_from_source_apc_00001_00001.mat';
job_file_name_scc = 'A_raw_from_source_scc_00001_00001.mat';




% job_file_dir = '/Users/matthewgiarra/Desktop/apc';
% job_file_name = 'A_deghost_apc_00001_00600.mat';

job_file_path_apc = fullfile(job_file_dir, job_file_name_apc);
job_file_path_rpc = fullfile(job_file_dir, job_file_name_rpc);
job_file_path_scc = fullfile(job_file_dir, job_file_name_scc);

% Load it
apc_job = load(job_file_path_apc);
rpc_job = load(job_file_path_rpc);
scc_job = load(job_file_path_scc);


% Pass to plot
pass_num = 5;

Skip = 2;

Scale = 1;

fSize_colorbar = 20;
fsize_y = 24;

tx_apc = apc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.X(:, 1);
ty_apc = apc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.Y(:, 1);

tx_rpc = rpc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.X(:, 1);
ty_rpc = rpc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.Y(:, 1);

tx_scc = scc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.X(:, 1);
ty_scc = scc_job.JobFile.Processing(pass_num).Results.Displacement.Raw.Y(:, 1);

gx = apc_job.JobFile.Processing(pass_num).Grid.Points.Full.X;
gy = apc_job.JobFile.Processing(pass_num).Grid.Points.Full.Y;


% quiver(gx(1 : Skip : end, 1 : Skip : end), ...
%        gy(1 : Skip : end, 1 : Skip : end), ...
%        Scale * tx(1 : Skip : end, 1 : Skip : end), ...
%        Scale * ty(1 : Skip : end, 1 : Skip : end), 0, 'b', 'linewidth', 2);
   
% axis image;

% hold on;

ny = length(unique(gy));
nx = length(unique(gx));

tx_grid_apc = reshape(tx_apc, [ny, nx]);
ty_grid_apc = reshape(ty_apc, [ny, nx]);

tx_grid_rpc = reshape(tx_rpc, [ny, nx]);
ty_grid_rpc = reshape(ty_rpc, [ny, nx]);

tx_grid_scc = reshape(tx_scc, [ny, nx]);
ty_grid_scc = reshape(ty_scc, [ny, nx]);

subtightplot(3, 1, 1);
imagesc(gx, gy, tx_grid_apc);
axis image;
ylabel('APC hybrid-instantaneous', 'FontSize', fsize_y, 'interpreter', 'latex');
set(gca, 'xtick', '');
set(gca, 'ytick', '');
c = caxis;
c_apc = colorbar;
ylabel(c_apc, 'Horizontal velocity (pix / frame)', 'interpreter', 'latex')
set(c_apc, 'fontsize', fSize_colorbar);
title({'Instantanous correlations, 5-pass deform', 'PIV Challenge 2014A, no image pre-processing'}, 'interpreter', 'latex', 'fontsize', 25);

subtightplot(3, 1, 2);
imagesc(gx, gy, tx_grid_rpc);
axis image;
ylabel('RPC instantaneous', 'FontSize', fsize_y, 'interpreter', 'latex');
set(gca, 'xtick', '');
set(gca, 'ytick', '');
caxis(c);
c_rpc = colorbar;
ylabel(c_rpc, 'Horizontal velocity (pix / frame)', 'interpreter', 'latex')
set(c_rpc, 'fontsize', fSize_colorbar);

subtightplot(3, 1, 3);
imagesc(gx, gy, tx_grid_scc);
axis image;
ylabel('SCC instantaneous', 'FontSize', fsize_y, 'interpreter', 'latex');
set(gca, 'xtick', '');
set(gca, 'ytick', '');
caxis(c);
c_scc = colorbar;
ylabel(c_scc, 'Horizontal velocity (pix / frame)', 'interpreter', 'latex')
set(c_scc, 'fontsize', fSize_colorbar);



set(gcf, 'color', 'white');








