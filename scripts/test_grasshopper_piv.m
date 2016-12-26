


JobList = PIVJobList_grasshopper;

frame_nums = 1 : 25 : 1000;

num_frames = length(frame_nums);

animal_number = 5;
trial_name = 'mng-2-073-C';

% Case directory
case_dir = fullfile(image_parent_dir, ...
    sprintf('grasshopper_%d', animal_number), trial_name);

for k = 1 : num_frames
   frame_num = frame_nums(k); 
   
    JobList(1).Processing(1).Frames.Start = frame_num;
    JobList(1).Processing(1).Frames.End = frame_num;

    output_file_paths = run_piv_job_list(JobList);

    load(output_file_paths{1});

    p = 1;

    frame_num = 1;

    tx = JobFile.Processing(p).Results.Displacement.Final.X;
    ty = JobFile.Processing(p).Results.Displacement.Final.Y;

    gx = JobFile.Processing(p).Grid.Points.Full.X;
    gy = JobFile.Processing(p).Grid.Points.Full.Y;

    figure(2);
    quiver(gx, gy, tx(:, frame_num), ty(:, frame_num), 0, '-k', 'linewidth', 1.5);
    axis image;
    set(gca, 'ydir', 'reverse');

    drawnow;
    
end

% xlim([1, 1000]);
% ylim([200, 700]);

