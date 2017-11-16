
% Pass number
pass_number = 5;

% Directory with all the results
results_dir = '/Users/matthewgiarra/Desktop/from_shannon/vect_2017_rpc_diameter_3';

% Base name
base_name = 'A_deghost_instantaneous_apc_hybrid_';

% Save directory
save_dir = '~/Desktop/piv_test_images';



% Get a list of the files
files = dir(fullfile(results_dir, sprintf('%s*.mat', base_name)));

% Number of files
num_files = length(files);

% Number of images
num_images = 0;

% Allocate image numbers
image_nums = zeros(2, num_files);

% Count the number of images from the file names 
for k = 1 : num_files
    image_nums(:, k) = sscanf(files(k).name, ...
        sprintf('%s%%05d_%%05d.mat', base_name));
    
    % Update the total number of images
    num_images = num_images + image_nums(2) - image_nums(1) + 1;

end

% First image
img_start = image_nums(1);
img_end = image_nums(end);

% Get the path first file. 
file_path = fullfile(files(1).folder, files(1).name);

% Load the first file to get some information from it.
load(file_path);

% Read the grid size
gx = JobFile.Processing(pass_number).Grid.Points.Full.X;
gy = JobFile.Processing(pass_number).Grid.Points.Full.Y;

% Number of grid points
num_points = length(gx);

% Allocate velocities
tx = zeros(num_points, num_images);
ty = zeros(num_points, num_images);
 
% Populate them
parfor k = 1 : num_files
    
    % Inform the user
    fprintf(1, 'On file %d of %d\n', k, num_files);
    
    % Get the path first file. 
    file_path = fullfile(files(k).folder, files(k).name);
    
    % Load the first file to get some information from it.
    jf  = load(file_path);
    
    % Save the velocity data to structure
    tx_load{k} = jf.JobFile.Processing(pass_number).Results.Displacement.Raw.X;
    ty_load{k} = jf.JobFile.Processing(pass_number).Results.Displacement.Raw.Y;
        
end

% Populate them
for k = 1 : num_files
    
    % Image numbers
    image_start = image_nums(1, k);
    image_end  = image_nums(2, k);
 
    % Populate the displacement vectors
    tx(:, image_start:image_end) = tx_load{k};   
    ty(:, image_start:image_end) = ty_load{k};

end




tx(tx == 0) = nan;
ty(ty == 0) = nan;

tx_mean = nanmean(tx, 2);
ty_mean = nanmean(ty, 2);

tx_std = nanstd(tx, [], 2);
ty_std = nanstd(ty, [], 2);


gx_cropped = gx(gx >=120 & gx <=2400);
gy_cropped = gy(gx >=120 & gx <=2400);
tx_mean_cropped = tx_mean(gx >=120 & gx <=2400);
tx_std_cropped = tx_std(gx >=120 & gx <=2400);

% Count the number of X and Y grid points
nx = length(unique(gx_cropped));
ny = length(unique(gy_cropped));


% Reshape the arrays
gx_mat = reshape(gx_cropped, [ny, nx]);
gy_mat = reshape(gy_cropped, [ny, nx]);
tx_mean_mat = reshape(tx_mean_cropped, [ny, nx]);
tx_rms_mat = reshape(tx_std_cropped, [ny, nx]);



Skip = 1;
Scale = 1;

% for k = 1 : num_images
%    
%     tx_current = tx(:, k);
%     ty_current = ty(:, k);
%     
%     tx_cropped = tx_current(gx >=120 & gx <=2400);
%     ty_cropped = ty_current(gx >=120 & gx <=2400);
%     
%     x = gx_cropped(1 : Skip : end, 1 : Skip : end);
%     y = gy_cropped(1 : Skip : end, 1 : Skip : end);
%     u = Scale * tx_cropped(1 : Skip : end, 1 : Skip : end);
%     v = Scale * ty_cropped(1 : Skip : end, 1 : Skip : end);
%     
%     u_mat = reshape(tx_cropped, [ny, nx]);
%     v_mat = reshape(ty_cropped, [ny, nx]);
%     
%     imagesc(gx_cropped(:), gy_cropped(:), u_mat);
%     caxis([-20, 60]);
%     colormap jet
%     hold on;
%     
%     quiver(x, y, u, v, 0, 'black', 'linewidth', 2);
%     axis image;
%     hold off;
%     
%     pause(0.3);
%     
%     
%     
%     
% end


figure; 
% Plot
subtightplot(1, 2, 1);
imagesc(gx, gy, tx_mean_mat);
axis image;
set(gca, 'ydir', 'normal');
colormap jet
caxis([-20, 60]);
g1 = get(gca, 'position');
c1 = colorbar;
set(c1, 'location', 'northoutside');
set(gca, 'position', g1);
axis off;

subtightplot(1, 2, 2);
imagesc(gx, gy, tx_rms_mat);
axis image;
set(gca, 'ydir', 'normal');
caxis([0, 22]);
g2 = get(gca, 'position');
c2 = colorbar;
set(c2, 'location', 'northoutside');
set(gca, 'position', g2);
axis off;




% % Save name
% save_name = sprintf('%s_%05d_%05d.mat', base_name(1 : end - 1), img_start, img_end);
% 
% % Save path
% save_path = fullfile(save_dir, save_name);
% 
% save(save_path, 'tx', 'ty', 'tx_mean', 'ty_mean', 'tx_std', 'ty_std', 'gx', 'gy');
% 
% 
% 





