function [region_height, region_width] = get_region_size(JOBFILE, PASS_NUMBER)

% Measure the region sizes
region_height = JOBFILE.Processing(PASS_NUMBER).Region.Height;
region_width = JOBFILE.Processing(PASS_NUMBER).Region.Height;

end