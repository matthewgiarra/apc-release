function JOBLIST = PIVJobList_default()

% Number of passes to run
num_passes_spec = 1;

% % % Pass parameters
region_height_list_raw = [64,  64];
region_width_list_raw  = [64, 64];
window_fract_list_raw = {0.5, 0.5};

% Grid stuff
grid_spacing_list_raw = [32, 32];
grid_spacing_list_raw_x = grid_spacing_list_raw;
grid_spacing_list_raw_y = grid_spacing_list_raw;
% grid_buffer_list_raw_x = {[32, 32], [32, 32]};
% grid_buffer_list_raw_y = {[32, 32], [32, 32]};

region_height_list = region_height_list_raw(1 : num_passes_spec);
region_width_list = region_width_list_raw(1 : num_passes_spec);
window_fract_list = window_fract_list_raw(1 : num_passes_spec);
grid_spacing_list_x = grid_spacing_list_raw_x(1 : num_passes_spec);
grid_spacing_list_y = grid_spacing_list_raw_y(1 : num_passes_spec);

% Total number of passes
num_passes_total = length(region_height_list);

% Number of passes
% zero means run all of them.
JobOptions.NumberOfPasses = 0;
JobOptions.StartPass = 1;
JobOptions.Parallel = false;
JobOptions.Register = false;

% Input images
Data.Inputs.Images.Directory = './images';
Data.Inputs.Images.BaseName = 'frame_';
Data.Inputs.Images.Digits = 5;
Data.Inputs.Images.Extension = '.tif';
Data.Inputs.Images.Trailers = {''};

% Source file path
Data.Inputs.SourceFilePath = '';

% Output vectors
Data.Outputs.Vectors.Directory = './vect';
Data.Outputs.Vectors.BaseName = 'vect_';
Data.Outputs.Vectors.Digits = 5;
Data.Outputs.Vectors.Extension = '.mat';

% Region stuff
Processing(1).Region.Height = 64;
Processing(1).Region.Width = 64;

% Window stuff
Processing(1).Window.Fraction = [0.5, 0.5];

% Grid stuff
Processing(1).Grid.Spacing.X = 32;
Processing(1).Grid.Spacing.Y = 32;
Processing(1).Grid.Shift.X = 0;
Processing(1).Grid.Shift.Y = 0;
Processing(1).Grid.Buffer.X = 32;
Processing(1).Grid.Buffer.Y = 32;

% Grid masking
Processing(1).Grid.Mask.Directory = './masks';
Processing(1).Grid.Mask.Name = 'mask.tif';

% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 600;
Processing(1).Frames.Step = 1;

% Correlation parameters
Processing(1).Correlation.Step = 0;
Processing(1).Correlation.Ensemble.DoEnsemble = false;
Processing(1).Correlation.Ensemble.NumberOfPairs = 10;
Processing(1).Correlation.Ensemble.Domain = 'spectral';
Processing(1).Correlation.Ensemble.Type = 'spatial';

% Parameters to specify spectral weighting method (APC, rpc, hybrid, etc)
Processing(1).Correlation.SpectralWeighting.Method = 'apc';

% Parameters specific to APC
Processing(1).Correlation.SpectralWeighting.APC.FilterDiameterUpperBound = 6;
Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Range = [0, 0];
Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Step = [0, 0];
Processing(1).Correlation.SpectralWeighting.APC.Thresh.X = [0, inf];
Processing(1).Correlation.SpectralWeighting.APC.Thresh.Y = [0, inf];
Processing(1).Correlation.SpectralWeighting.APC.Method = 'magnitude';
Processing(1).Correlation.DisplacementEstimate.Domain = 'spatial';

% Parameters specific to RPC
Processing(1).Correlation.RPC.EffectiveDiameter = 3;

% Estimated particle diameter
Processing(1).Correlation.EstimatedParticleDiameter = 3;

% Subpixel fit parameters
Processing(1).SubPixel.Method = '3-point fit';
Processing(1).SubPixel.EstimatedParticleDiameter = 3;

% Parameters for vector validation
Processing(1).Validation.DoValidation = 1;
Processing(1).Validation.ValidationMethod = 'uod';

% Parameters for smoothing
Processing(1).Smoothing.DoSmoothing = 1;
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

    % Grid
    piv_pass.Grid.Spacing.Y = grid_spacing_list_y(p);
    piv_pass.Grid.Spacing.X = grid_spacing_list_x(p);
    piv_pass.Grid.Buffer.X = region_width_list(p)/2;
    piv_pass.Grid.buffer.Y = region_height_list(p)/2;

    % Window
    piv_pass.Window.Fraction = window_fract_list{p};


    % Add to the structure
    Processing(p) = piv_pass;    
end

% Add the fields to the jobfile structure.
JobFile.Data = Data;
JobFile.Processing = Processing;
JobFile.JobOptions = JobOptions;

% Output variable
JOBLIST = JobFile;

end





