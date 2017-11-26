
% Specify the job file to plot

% Pass to plot

load('~/Desktop/results_skip.mat');

Skip = 2;
Scale = 1;

fSize_colorbar = 20;
fsize_y = 24;

num_files = size(tx, 1);


% p = 68;
c = [0, 15];


gf = [ 1181          26         761        1312];
xl = [120, 2400];

Skip = 2;
Scale = 1.5;
p = 1;
plot_vectors = false;
lw = 1;

fSize_title = 20;
fSize_labels = 15;
fSize_legend = 16;
fSize_axes = 16;

% Number of passes
num_passes = size(gx, 2);

w = [128, 128, 32, 32, 32, 32];
h = [64, 64, 32, 32, 32, 32];

save_dir = '~/Desktop/plots';

for p = 1 : length(w)

% Plotting filter diameters.
for k = 1 : num_files
    
    is_deghost = ~isempty(regexpi(job_file_name{k}, 'deghost'));
    if is_deghost
        y_label = 'Deghosted images';
        plot_num = 2;
    else
        y_label = 'Raw images';
        plot_num = 1;
    end

%     is_new = ~isempty(regexpi(job_file_name{k}, 'no_min_ac'));
%     is_original = ~isempty(regexpi(job_file_name{k}, 'original'));
%     if is_new
%         y_label = 'New code, new filter val (newest results)';
%         plot_num = 3;
%     elseif is_original
%         y_label = 'Original processing (in manuscript)';
%         plot_num = 1;
%     else
%         y_label = 'New code, no filter val (few days ago)';
%         plot_num = 2;
%     end
    
    plot_num = k;
    
    % Grid spacing
    dx = min(diff(unique(gx{1, p})));
    dy = min(diff(unique(gy{1, p})));
    
    subtightplot(3, 1, plot_num, [], [0.2, 0.2], []);

    % Plot the filters
    imagesc(gx{k, p}, gy{k, p}, sx_grid{k, p});
    ga = get(gca, 'position');
    cb = colorbar;
    set(gca, 'position', ga);
    axis image;
    caxis(c);
    set(gca, 'fontsize', fSize_axes);
    ylabel(cb, 'APC Diameter (x)', ...
    'interpreter', 'latex', ...
    'fontsize', fSize_legend);
    hold on;
%     set(gca, 'fontsize', fSize_legend);

    
    % Plot vectors
    if plot_vectors
        quiver(gx{k, p}(1 : Skip : end, 1 : Skip : end), ...
           gy{k, p}(1 : Skip : end, 1 : Skip : end), ...
           Scale * tx{k, p}(1 : Skip : end, 1 : Skip : end), ...
           Scale * ty{k, p}(1 : Skip : end, 1 : Skip : end), ...
           0, 'black', 'linewidth', lw);    
    end
    hold off;
    ylabel(y_label, 'interpreter', 'latex', 'fontsize', fSize_labels);
    
    set(gca, 'xtick', '');
    set(gca, 'ytick', '');
    

%     ylabel(y_label, 'fontsize', 16, 'interpreter', 'latex');
%     title(strrep(job_file_name{k}, '_', '\_'), 'fontsize', 12);
    if plot_num == 1
        title({'Colors show APC diameter in terms of particle size',...
            sprintf('Ensemble w/deform, pass %d of %d', p, num_passes), ...
            sprintf('Region size: %d x %d, Grid size: %d x %d', w(p), h(p), dx, dy)},...
            'fontsize', fSize_title, ...
            'interpreter', 'latex');
    end
    
    % Xlimits
    xlim(xl);

%     set(gcf, 'color', 'white');
    set(gcf, 'color', 'white', 'position', gf);
    
    save_name = sprintf('plot_%2d.png', p);
    save_path = fullfile(save_dir, save_name);
    export_fig('-r200', save_path);
    
    
end

end

% 
% figure(2);
% c_velocity = [-15, 50];
% for k = 1 : num_files
%     
%     is_deghost = ~isempty(regexpi(job_file_name{k}, 'deghost'));
%     if is_deghost
%         y_label = 'Deghosted images';
%         plot_num = 2;
%     else
%         y_label = 'Raw images';
%         plot_num = 1;
%     end
% % 
% %     is_new = ~isempty(regexpi(job_file_name{k}, 'no_min_ac'));
% %     is_original = ~isempty(regexpi(job_file_name{k}, 'original'));
% %     if is_new
% %         y_label = 'New code, new filter val (newest results)';
% %         plot_num = 3;
% %     elseif is_original
% %         y_label = 'Original processing (in manuscript)';
% %         plot_num = 1;
% %     else
% %         y_label = 'New code, no filter val (few days ago)';
% %         plot_num = 2;
% %     end
%     
%     plot_num = k;
%     
%     subtightplot(3, 1, plot_num, [], [0.2, 0.2], []);
% 
%     % Plot the filters
%     imagesc(gx{k, p}, gy{k, p}, tx_grid{k, p});
%     ga = get(gca, 'position');
%     cb = colorbar;
%     set(gca, 'position', ga);
%     axis image;
%     set(gca, 'fontsize', fSize_axes);
%     ylabel(cb, 'U velocity (pix/frame)', ...
%     'interpreter', 'latex', ...
%     'fontsize', fSize_legend);
%     hold on;
%     caxis(c_velocity);
% %     set(gca, 'fontsize', fSize_legend);
% 
%     
%     % Plot vectors
%     if plot_vectors
%         quiver(gx{k, p}(1 : Skip : end, 1 : Skip : end), ...
%            gy{k, p}(1 : Skip : end, 1 : Skip : end), ...
%            Scale * tx{k, p}(1 : Skip : end, 1 : Skip : end), ...
%            Scale * ty{k, p}(1 : Skip : end, 1 : Skip : end), ...
%            0, 'black', 'linewidth', lw);    
%     end
%     hold off;
%     ylabel(y_label, 'interpreter', 'latex', 'fontsize', fSize_labels);
%     
%     set(gca, 'xtick', '');
%     set(gca, 'ytick', '');
%     
% 
% %     ylabel(y_label, 'fontsize', 16, 'interpreter', 'latex');
% %     title(strrep(job_file_name{k}, '_', '\_'), 'fontsize', 12);
%     if plot_num == 1
%         title({'Colors show U-velocity', ...
%             '6-pass ensemble w/deform, final grid 16x16', ...
%             'Raw velocity (no UOD on final pass of vectors)'},...
%             'fontsize', fSize_title, ...
%             'interpreter', 'latex');
%     end
%     
%     % Xlimits
%     xlim(xl);
% 
% %     set(gcf, 'color', 'white', 'position', gf);
%     set(gcf, 'color', 'white');
%     
%     
% end
% 



% save('~/Desktop/results_fine_grid.mat', 'job_file_name', 'tx', 'ty', 'gx', 'gy', 'tx_grid', 'ty_grid' ,'sx_grid', 'sy_grid', 'sx_val', 'sy_val', 'sx_val_grid', 'sy_val_grid', 'is_outlier_grid', 'ny', 'nx');






