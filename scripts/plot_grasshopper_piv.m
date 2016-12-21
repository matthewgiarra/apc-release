
results_path = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/grasshopper/grasshopper_3/mng-2-072-B/vect/mng-2-072-B_000001_005450.mat';
reg_path = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/grasshopper/grasshopper_3/mng-2-072-B/proc/reg/points/mng-2-072-B_reg_000000-005457.mat';

fSize_legend = 20;
fSize_labels = 24;
fSize_axes = 24;

kernel_size = 80;

x = -kernel_size/2 : kernel_size/2;
g_std = 5;
kern = 1 / sqrt(2 * pi * g_std^2) * exp(-x.^2/(2*g_std^2));

load(results_path);

tx_piv_raw = -1 * max(JobFile.Processing(1).Results.Displacement.Raw.X);
tx_piv_smoothed = conv(tx_piv_raw, kern, 'same');
piv_time_ms = 1 : length(tx_piv_smoothed);
piv_time_sec = 1 / 1000 * piv_time_ms;

load(reg_path);
tx_reg = tx_smoothed;
tx_reg_diff = diff(tx_reg);
reg_time_ms = 1 : length(tx_reg_diff);
reg_time_sec = 1 / 1000 * reg_time_ms;

Skip = 10;
plot(piv_time_sec( 1 : Skip : end), tx_piv_raw(1 : Skip : end), '-', 'color', 0.75 * [1, 1, 1], 'linewidth', 1.5)

hold on;
% Plot the PIV results
p_fill = area(piv_time_sec, tx_piv_smoothed);
p_fill.FaceColor = [0, 1, 0];
p_fill.FaceAlpha = 0.5;
p_fill.EdgeAlpha = 0;
p_fill.ShowBaseLine = 'on';
p_fill.LineStyle = '-';
p_fill.EdgeColor = [0, 0, 0];
p_fill.LineWidth = 1.5;

plot(piv_time_sec, tx_piv_smoothed, '-k', 'linewidth', 1.5);
hold off
pbaspect([3, 1, 1]);
set(gcf, 'color', 'white');
h = legend('Raw', 'Smoothed');
set(h, 'FontSize', fSize_legend);
set(gca, 'fontsize', fSize_axes);
xlabel('$\textrm{Time (seconds)}$', 'interpreter', 'latex', 'FontSize', fSize_labels);
ylabel('$\textrm{Flow velocity (mm/sec)}$', 'interpreter', 'latex', 'FontSize', fSize_labels);

grid on;

x_lim_max = max([max(piv_time_sec), max(reg_time_sec)]);
xlim([1, x_lim_max]);
ylim([-20, 20]);

