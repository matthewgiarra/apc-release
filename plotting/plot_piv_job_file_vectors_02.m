
% Specify the job file to plot

% Pass to plot


Skip = 2;
Scale = 1;

fSize_colorbar = 20;
fsize_y = 24;


% job_file_dir = '/Users/matthewgiarra/Desktop/piv_test_images/piv_challenge/2014/A/vect_2017-11-18/apc';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/new_rpcd6';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/old';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/original';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/compare_thresholds';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/compare_fields';
% job_file_dir = '/Users/matthewgiarra/Desktop/apc/cropped';
job_file_dir = '/Users/matthewgiarra/Desktop/apc/filter_validation';
files = dir(fullfile(job_file_dir, './*.mat'));

% Number of files
num_files = length(files);

% load('~/Desktop/results.mat');


for k = 1 : num_files
  
    job_file_name{k} = files(k).name;
    job_file_path = fullfile(job_file_dir, job_file_name{k});
    
    load(job_file_path);
  
    % Number of passes
    num_passes = length(JobFile.Processing);
    
    for p = 1 : num_passes
    
        tx{k, p} = JobFile.Processing(p).Results.Displacement.Raw.X(:, 1);
        ty{k, p} = JobFile.Processing(p).Results.Displacement.Raw.Y(:, 1);

        gx{k, p} = JobFile.Processing(p).Grid.Points.Full.X;
        gy{k, p} = JobFile.Processing(p).Grid.Points.Full.Y;

        sx = JobFile.Processing(p).Results.Filtering.APC.Diameter.X(:, 1);
        sy = JobFile.Processing(p).Results.Filtering.APC.Diameter.Y(:, 1);

        ny{k, p} = length(unique(gy{k, p}));
        nx{k, p} = length(unique(gx{k, p}));

        tx_grid = reshape(tx{k, p}, [ny{k, p}, nx{k, p}]);
        ty_grid = reshape(ty{k, p}, [ny{k, p}, nx{k, p}]);
        sx_grid{k, p} = reshape(sx, [ny{k, p}, nx{k, p}]);
        sy_grid{k, p} = reshape(sy, [ny{k, p}, nx{k, p}]);

        % Validate the filters
        [sx_val_temp, sy_val_temp, is_outlier_temp] = ...
                validateField_prana(gx{k, p}, gy{k, p}, sx, sy, 0.5 * [1, 1]);
            
        % Set nans     
        sx_val_temp(isnan(tx{k, p}) | tx{k, p} == 0) = nan;
        sy_val_temp(isnan(ty{k, p}) | ty{k, p} == 0) = nan;
        is_outlier_temp(isnan(tx{k, p}) | tx{k, p} == 0) = nan;
        
        sx_val{k, p} = sx_val_temp;
        sy_val{k, p} = sy_val_temp;
        
        sx_val_grid{k, p} =  reshape(sx_val_temp, [ny{k, p}, nx{k, p}]);
        sy_val_grid{k, p} =  reshape(sy_val_temp, [ny{k, p}, nx{k, p}]);
        
        is_outlier_grid{k, p} = reshape(is_outlier_temp, [ny{k, p}, nx{k, p}]);
        
        
    end

end

num_files = size(tx, 1);



% p = 68;
c = [0, 15];


gf = [ 1000         201         942        1137];
xl = [120, 2400];

Skip = 3;
Scale = 1;
p = 6;
plot_vectors = true;
lw = 1;
% Plotting filter diameters.
for k = 1 : num_files
    
%     is_deghost = ~isempty(regexpi(job_file_name{k}, 'deghost'));
%     if is_deghost
%         y_label = 'Deghosted images';
%         plot_num = 2;
%     else
%         y_label = 'Raw images';
%         plot_num = 1;
%     end

    is_new = ~isempty(regexpi(job_file_name{k}, 'val'));
    if is_new
        y_label = 'UOD on CC + autocorr + threshold';
        plot_num = 2;
    else
        y_label = 'UOD on CC only ';
        plot_num = 1;
    end
    
    
    plot_num = k;
    subtightplot(2, 1, plot_num, [], [0.2, 0.2], []);
%     outlier_inds = find(is_outlier_grid{k, p}(:) > 0);
%     
%     x = gx{k, p}(outlier_inds);
%     y = gy{k, p}(outlier_inds);

    if is_new
        imagesc(gx{k, p}, gy{k, p}, sx_grid{k, p});
    else
        imagesc(gx{k, p}, gy{k, p}, sx_val_grid{k, p});
    end
    
    axis image;
    caxis(c);
    hold on;
%     plot(x, y, '.w', 'markersize', 5);
    ylabel(y_label, 'interpreter', 'latex', 'fontsize', 16);
    
    % Plot vectors
    if plot_vectors
        quiver(gx{k, p}(1 : Skip : end, 1 : Skip : end), ...
           gy{k, p}(1 : Skip : end, 1 : Skip : end), ...
           Scale * tx{k, p}(1 : Skip : end, 1 : Skip : end), ...
           Scale * ty{k, p}(1 : Skip : end, 1 : Skip : end), ...
           0, 'black', 'linewidth', lw);
        
    end
    
    
    hold off;
    set(gca, 'xtick', '');
    set(gca, 'ytick', '');
    

%     ylabel(y_label, 'fontsize', 16, 'interpreter', 'latex');
%     title(strrep(job_file_name{k}, '_', '\_'), 'fontsize', 12);
    if plot_num == 1
        title('Validated APC diameters, raw velocities',...
            'fontsize', 16, ...
            'interpreter', 'latex');
    end
    
    ga = get(gca, 'position');
    cb = colorbar;
    ylabel(cb, 'APC Diameter (x)', ...
    'interpreter', 'latex', ...
    'fontsize', 20);
    set(gca, 'position', ga);
   
    set(gca, 'fontsize', 20);
    xlim(xl);

    % set(gcf, 'color', 'white', 'position', gf);
    set(gcf, 'color', 'white');
    
    
end











