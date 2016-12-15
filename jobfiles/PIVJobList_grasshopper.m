function JOBLIST = PIVJobList_grasshopper()

% Number of passes to run
num_passes_spec = 1;

% % % Pass parameters
% region_height_list_raw = [128, 64];
% region_width_list_raw = [128, 64];
% window_fract_list_raw = {0.5, 0.5};
% grid_spacing_list_raw = [64, 64];
% grid_spacing_list_raw_x = grid_spacing_list_raw;
% grid_spacing_list_raw_y = grid_spacing_list_raw;

region_height_list_raw = 128;
region_width_list_raw = 128;
window_fract_list_raw = 0.5;
grid_spacing_list_raw_x = 16;
grid_spacing_list_raw_y = 16;

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


image_parent_dir = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/grasshopper/';
animal_number = 6;
trial_name = 'mng-2-073-G';


% Case directory
case_dir = fullfile(image_parent_dir, sprintf('grasshopper_%d', animal_number), trial_name);

% Data: Input images

Data.Inputs.Images.Directory = fullfile(case_dir, 'raw');
Data.Inputs.Images.BaseName = sprintf('%s_', trial_name);
Data.Inputs.Images.Digits = 6;
Data.Inputs.Images.Extension = '.tiff';
% Data.Inputs.Images.Trailers = {'_a', '_b'};
Data.Inputs.Images.Trailers = {'', ''};

% Data: Input vectors for initializing, e.g., image deformation.
Data.Inputs.Vectors.Directory = '';
Data.Inputs.Vectors.BaseName = '';
Data.Inputs.Vectors.Digits = 5;
Data.Inputs.Vectors.Extension = '.mat';

% Data: output vectors
% Data.Outputs.Vectors.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/vect';
Data.Outputs.Vectors.Directory = fullfile(case_dir, 'vect');
Data.Outputs.Vectors.BaseName = sprintf('%s_', trial_name);
Data.Outputs.Vectors.Digits = 6;
Data.Outputs.Vectors.Extension = '.mat';

% Interrogation region dimensions
Processing(1).Region.Height = 128;
Processing(1).Region.Width = 128;

% Spatial window
Processing(1).Window.Fraction = 0.5;

% Grid parameters
Processing(1).Grid.Spacing.Y = 64;
Processing(1).Grid.Spacing.X = 64;
Processing(1).Grid.Shift.Y = -16;
Processing(1).Grid.Shift.X = 0;
Processing(1).Grid.Buffer.Y = 0;
Processing(1).Grid.Buffer.X = 0;
Processing(1).Grid.Mask.Directory = fullfile(case_dir, 'mask');
Processing(1).Grid.Mask.Name = sprintf('%s_mask.tiff', trial_name);
% Processing(1).Grid.Mask.Directory = '';
% Processing(1).Grid.Mask.Name = '';

% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 1000;
Processing(1).Frames.Step = 50;

% Correlation parameters
Processing(1).Correlation.Method = 'rpc';
% Processing(1).Correlation.Step = 0;
Processing(1).Correlation.Step = 2;
Processing(1).Correlation.Ensemble.DoEnsemble = 1;
Processing(1).Correlation.Ensemble.NumberOfPairs = 1;
Processing(1).Correlation.Ensemble.Domain = 'spectral';
Processing(1).Correlation.Ensemble.Direction = 'spatial';

% Parameters specific to APC
Processing(1).Correlation.APC.FilterDiameterUpperBound = 1;
Processing(1).Correlation.APC.Shuffle.Range = [0, 0];
Processing(1).Correlation.APC.Shuffle.Step = [0, 0];
Processing(1).Correlation.APC.Method = 'phase';

% Parameters specific to RPC
Processing(1).Correlation.RPC.EffectiveDiameter = 6;

% Subpixel fit parameters
Processing(1).SubPixel.Method = '3-point fit';
Processing(1).SubPixel.EstimatedParticleDiameter = 2;

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
JOBLIST(1) = JobFile;


end



