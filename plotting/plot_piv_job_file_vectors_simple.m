
job_file_path = '/Users/matthewgiarra/Desktop/piv_test_images/piv_challenge/2014/A/vect_2017-11-26/hybrid/A_raw_hybrid_00001_00016.mat';
job_file_path = '/Users/matthewgiarra/Desktop/apc/source/A_raw_apc_ensemble_00001_00600';



% Pass number
p = 6;

% Pair number
n = 10; 

% Load job file
load(job_file_path);



% Displacements
tx = JobFile.Processing(p).Results.Displacement.Validated.X(:, n);
ty = JobFile.Processing(p).Results.Displacement.Validated.Y(:, n);

% Grid
gx = JobFile.Processing(p).Grid.Points.Full.X;
gy = JobFile.Processing(p).Grid.Points.Full.Y;

% Number of points in each direction
ny = length(unique(gy));
nx = length(unique(gx));

sx = JobFile.Processing(p).Results.Filtering.Diameter.X(:, 1);
sx_mat = reshape(sx, [ny, nx]);

% Reshape
tx_mat = reshape(tx, [ny, nx]);

imagesc(gx, gy, sx_mat);
% caxis([-15, 60]);
caxis([5, 20])
hold on;
% quiver(gx, gy, tx, ty, 0, 'w');
hold off
axis image;