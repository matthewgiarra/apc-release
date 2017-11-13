
% Specify the job file to plot


job_file_dir = '/Users/matthewgiarra/Desktop/piv_test_images/pivchallenge/2014/A/vect/test/';
job_file_name = 'A_deghost_from_source_00001_00001.mat';


% job_file_dir = '/Users/matthewgiarra/Desktop/apc';
% job_file_name = 'A_deghost_apc_00001_00600.mat';

job_file_path = fullfile(job_file_dir, job_file_name);

% Load it
load(job_file_path);

% Pass to plot
pass_num = 1;

Skip = 1;

Scale = 1;


tx = JobFile.Processing(pass_num).Results.Displacement.Validated.X(:, 1);
ty = JobFile.Processing(pass_num).Results.Displacement.Validated.Y(:, 1);

gx = JobFile.Processing(pass_num).Grid.Points.Full.X;
gy = JobFile.Processing(pass_num).Grid.Points.Full.Y;


quiver(gx(1 : Skip : end, 1 : Skip : end), ...
       gy(1 : Skip : end, 1 : Skip : end), ...
       Scale * tx(1 : Skip : end, 1 : Skip : end), ...
       Scale * ty(1 : Skip : end, 1 : Skip : end), 0, 'k');