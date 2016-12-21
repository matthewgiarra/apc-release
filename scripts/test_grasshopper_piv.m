


JobList = PIVJobList_grasshopper;
output_file_paths = run_piv_job_list(JobList);

load(output_file_paths{1});

p = 1;

frame_num = 1;

tx = JobFile.Processing(p).Results.Displacement.Raw.X;
ty = JobFile.Processing(p).Results.Displacement.Raw.Y;

gx = JobFile.Processing(p).Grid.Points.Full.X;
gy = JobFile.Processing(p).Grid.Points.Full.Y;

quiver(gx, gy, tx(:, frame_num), ty(:, frame_num), 0, '-k', 'linewidth', 1.5);
axis image;
set(gca, 'ydir', 'reverse');
xlim([1, 1000]);
ylim([200, 700]);

