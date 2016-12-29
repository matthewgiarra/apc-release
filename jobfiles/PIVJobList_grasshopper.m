function JOBLIST = PIVJobList_grasshopper(RUN_JOBS)

% Default to no variables in
if nargin < 1
    RUN_JOBS = false;
end

% Number of passes to run
num_passes_spec = 1;

% Particle diameter
dp = 12;

% Trial names
trial_names{1} = 'mng-2-071-J';
trial_names{2} = 'mng-2-072-B';
trial_names{3} = 'mng-2-073-C';
trial_names{4} = 'mng-2-073-F';
trial_names{5} = 'mng-2-073-G';

% Anumal numbers
animal_numbers = [2, 3, 5, 6, 6];

% Moving subtraction window size list
% mean_sub_window_size_list = [9, 9, 9, 9, 9];
% mean_sub_window_size_list = 9 * [1, 1, 1, 1, 1];

window_size_list = [2, 4, 6, 9];

% Frames
start_frame = 1;
end_frame = 5450;
% end_frame = 1;
skip_frames = 1;

% This can be changed to prune the trials list.
% trials_to_run = 1 : length(animal_numbers);
% 
trials_to_run = [1, 2, 3, 4, 5];
% trials_to_run = 1;

% Number of trials to run
num_trials = length(trials_to_run);

% Loop over the list of moving-mean window sizes.
for p = 1 : length(window_size_list)
    
    % Read the moving mean window size and assign it.
    mean_sub_window_size_list = ...
        window_size_list(p) * ones(num_trials, 1);
    
    % % % Pass parameters
    region_height_list_raw = 128;
    region_width_list_raw = 256;
    window_fract_list_raw = {[0.75, 0.75]};
    grid_spacing_list_raw_x = 32;
    grid_spacing_list_raw_y = 32;

    region_height_list = region_height_list_raw(1 : num_passes_spec);
    region_width_list = region_width_list_raw(1 : num_passes_spec);
    window_fract_list = window_fract_list_raw(1 : num_passes_spec);
    grid_spacing_list_x = grid_spacing_list_raw_x(1 : num_passes_spec);
    grid_spacing_list_y = grid_spacing_list_raw_y(1 : num_passes_spec);

    % Number of passes
    % zero means run all of them.
    JobOptions.NumberOfPasses = 0;

    % Total number of passes
    num_passes_total = length(region_height_list);

    % Image parent directory
    image_parent_dir = ['/Users/matthewgiarra/Documents/' ...
        'School/VT/Research/Aether/piv_test_images/grasshopper/'];

    % Get today's date
    date_vect = datevec(datetime('now'));
    year = date_vect(1);
    month = date_vect(2);
    day = date_vect(3);

    date_string = sprintf('%d-%02d-%02d', year, month, day);

    for n = 1 : num_trials

        % Trial number
        trial_number = trials_to_run(n);

        % Animal number
        animal_number = animal_numbers(trial_number);

        % Trial name
        trial_name = trial_names{trial_number};

        % Case directory
        case_dir = fullfile(image_parent_dir, ...
            sprintf('grasshopper_%d', animal_number), trial_name);

        % Moving mean subtraction window size
        mean_sub_window_size = mean_sub_window_size_list(trial_number);

        % Data: Input images

        Data.Inputs.Images.Directory = fullfile(case_dir, 'proc', 'deriv', sprintf('win_size_%02d', mean_sub_window_size));
        Data.Inputs.Images.BaseName = sprintf('%s_', trial_name);
        Data.Inputs.Images.Digits = 6;
        Data.Inputs.Images.Extension = '.tiff';
        Data.Inputs.Images.Trailers = {'', ''};

        % Data: Input vectors for initializing, e.g., image deformation.
        Data.Inputs.Vectors.Directory = '';
        Data.Inputs.Vectors.BaseName = '';
        Data.Inputs.Vectors.Digits = 5;
        Data.Inputs.Vectors.Extension = '.mat';

        % Data: output vectors
        Data.Outputs.Vectors.Directory = fullfile(case_dir, 'vect', date_string, sprintf('vect_skip_%02d', skip_frames));
        Data.Outputs.Vectors.BaseName = sprintf('%s_w%d_h%d_win_%02d_', trial_name, region_height_list(1), region_width_list(1), mean_sub_window_size);
        Data.Outputs.Vectors.Digits = 6;
        Data.Outputs.Vectors.Extension = '.mat';

        % Interrogation region dimensions
        Processing(1).Region.Height = 128;
        Processing(1).Region.Width = 256;

        % Spatial window
        Processing(1).Window.Fraction = 0.5;

        % Grid parameters
        Processing(1).Grid.Spacing.Y = 32;
        Processing(1).Grid.Spacing.X = 32;
        Processing(1).Grid.Shift.Y = 0;
        Processing(1).Grid.Shift.X = 0;
        Processing(1).Grid.Buffer.Y = 0;
        Processing(1).Grid.Buffer.X = 0;
        Processing(1).Grid.Mask.Directory = fullfile(case_dir, 'mask');
        Processing(1).Grid.Mask.Name = sprintf('%s_mask.tiff', trial_name);

        % Frame parameters.
        Processing(1).Frames.Start = start_frame;
        Processing(1).Frames.End = end_frame;
        Processing(1).Frames.Step = skip_frames;

        % Correlation parameters
        Processing(1).Correlation.Step = 1;
        Processing(1).Correlation.Ensemble.DoEnsemble = 1;
        Processing(1).Correlation.Ensemble.NumberOfPairs = 1;
        Processing(1).Correlation.Ensemble.Domain = 'spectral';
        Processing(1).Correlation.Ensemble.Direction = 'spatial';

        % Spectral weighting: SCC, RPC, GCC, APC
        Processing(1).Correlation.SpectralWeighting.Method = 'RPC';

        % APC Parameters
        % Parameters specific to APC
        Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Range = [0, 0];
        Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Step = [0, 0];
        Processing(1).Correlation.SpectralWeighting.APC.Method = 'phase';

        % Spectral filtering parameters
        % These are things like the phase median filter,
        % SVD, etc. 
        Processing(1).Correlation.SpectralFiltering.FilterList = {''};
        Processing(1).Correlation.SpectralFiltering.KernelSizeList = {''};

        % This specifies the domain in which the displacement
        % estimate is calculated ('spatial' for peak-finding/fitting 
        % or 'spectral' for SPC plane fit);
        Processing(1).Correlation.DisplacementEstimate.Domain = 'spatial';

        % Choose whether to run compiled codes
        Processing(1).Correlation.DisplacementEstimate. ...
            Spectral.RunCompiled = true;

        % Options for spatial displacement estimate
        Processing(1).Correlation.DisplacementEstimate. ...
            Spatial.SubPixel.Method = '3-point fit';

        % Estimated particle diameter
        Processing(1).Correlation.EstimatedParticleDiameter = dp;

        % Options for spectral displacement estimate
        Processing(1).Correlation.DisplacementEstimate. ...
            Spectral.UnwrappingMethod = 'goldstein';

        % Parameters for vector validation
        Processing(1).Validation.DoValidation = 0;
        Processing(1).Validation.ValidationMethod = 'uod';

        % Parameters for smoothing
        Processing(1).Smoothing.DoSmoothing = 0;
        Processing(1).Smoothing.KernelDiameter = 7;
        Processing(1).Smoothing.KernelStdDev = 1;

        % Parameters for iterative method
        Processing(1).Iterative.Method = 'deform';
        Processing(1).Iterative.Deform.Interpolation = 'interp2'; 
        Processing(1).Iterative.Deform.ConvergenceCriterion = 0.1;
        Processing(1).Iterative.Deform.MaxIterations = 1;
        Processing(1).Iterative.Source.Directory = '';
        Processing(1).Iterative.Source.Name = '';
        Processing(1).Iterative.Source.PassNumber = 0;

        % Default Processing
        default_processing = Processing(1);

        % Loop over all the passes
        for p = 1 : num_passes_total

           % Copy the default pass
           piv_pass = default_processing; 

           % Region size
           piv_pass.Region.Height = region_height_list(p);
           piv_pass.Region.Width  = region_width_list(p);

           % Grid buffers
           piv_pass.Grid.Buffer.X = region_width_list(p)/2;
           piv_pass.Grid.buffer.Y = region_height_list(p)/2;

            % Window
            if iscell(window_fract_list)
                piv_pass.Window.Fraction = window_fract_list{p};
            else
                piv_pass.Window.Fraction = window_fract_list(p);
            end

           % Grid
           piv_pass.Grid.Spacing.Y = grid_spacing_list_y(p);
           piv_pass.Grid.Spacing.X = grid_spacing_list_x(p);

           % Add to the structure
           Processing(p) = piv_pass;    
        end

        % Add the fields to the jobfile structure.
        JobFile.Data = Data;
        JobFile.Processing = Processing;
        JobFile.JobOptions = JobOptions;

        % Append to the job list.
        JOBLIST(n) = JobFile;

    end

    % Run the jobs if specified.
    if RUN_JOBS == true
        run_piv_job_list(JOBLIST);
    end

end


end



