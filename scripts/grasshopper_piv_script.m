% Image parent directory
image_parent_dir = ['/Users/matthewgiarra/Documents/' ...
    'School/VT/Research/Aether/piv_test_images/grasshopper/'];
animal_number = 5;
trial_name = 'mng-2-073-C';

% Case directory
case_dir = fullfile(image_parent_dir, ...
    sprintf('grasshopper_%d', animal_number), trial_name);

win_size_list = 1 : 10;


num_jobs = length(win_size_list);

parfor k = 1 : num_jobs
   
    win_size = win_size_list(k);
    
    % Load job list
    JobList = PIVJobList_grasshopper;
    
    % Image dir string
    image_dir_str = sprintf('win_size_%02d', win_size);
    
    % Update job list
    
    JobList.Data.Inputs.Images.Directory = fullfile(case_dir, 'proc', 'deriv', image_dir_str);
    JobList.Data.Outputs.Vectors.Directory = fullfile(case_dir, 'vect', image_dir_str);
    
    run_piv_job_list(JobList);
    
end