function surfn(DATA)

[region_height, region_width] = size(DATA);

surf(DATA ./ max(DATA(:)));

xlim([1, region_width]);
ylim([1, region_height]);
zlim([0, 1]);
axis square;
set(gcf, 'color', 'white');
set(gca, 'view', [-37.50, 20]);
box on;
drawnow;

end