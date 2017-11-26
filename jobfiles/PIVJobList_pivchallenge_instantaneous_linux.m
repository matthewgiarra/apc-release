function JOBLIST = PIVJobList_pivchallenge_instantaneous_linux()

% Number of passes to run
num_passes_spec = 6;

% % % Pass parameters
region_height_list_raw = [64,  64,  32, 32, 32, 32];
region_width_list_raw  = [128, 128, 32, 32, 32, 32];
window_fract_list_raw = {[0.5, 0.5; 0.5, 1], ...
                         [0.5, 0.5; 0.5, 1], ...
                         0.5, 0.5, 0.5, 0.5};

% Grid stuff
grid_spacing_list_raw = [32, 32, 16, 16, 16, 8];
grid_spacing_list_raw_x = grid_spacing_list_raw;
grid_spacing_list_raw_y = grid_spacing_list_raw;

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

% Data: Input images
% Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/proc/ghost';
Data.Inputs.Images.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/raw';
% Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/poiseuille_diffusion_0.00/raw';
% Data.Inputs.Images.BaseName = 'A_deghost_';
Data.Inputs.Images.BaseName = 'A_';
% Data.Inputs.Images.BaseName = 'poiseuille_diffusion_0.00_';
Data.Inputs.Images.Digits = 5;
Data.Inputs.Images.Extension = '.tif';
Data.Inputs.Images.Trailers = {'_a', '_b'};
% Data.Inputs.Images.Trailers = {''};

% Source file path
Data.Inputs.SourceFilePath = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-21/apc/A_raw_apc_ensemble_00001_00600.mat';

% Data: output vectors
Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/apc';
Data.Outputs.Vectors.BaseName = 'A_apc_';
Data.Outputs.Vectors.Digits = 5;
Data.Outputs.Vectors.Extension = '.mat';

% Interrogation region dimensions
Processing(1).Region.Height = 64;
Processing(1).Region.Width = 128;
% Processing(1).Region.Height = 128;
% Processing(1).Region.Width = 128;

% Spatial window
Processing(1).Window.Fraction = [0.5, 0.5; 0.5, 1];

% Grid parameters
Processing(1).Grid.Spacing.Y = 64;
Processing(1).Grid.Spacing.X = 64;
Processing(1).Grid.Shift.Y = -16;
Processing(1).Grid.Shift.X = 0;
Processing(1).Grid.Buffer.Y = 0;
Processing(1).Grid.Buffer.X = 0;
Processing(1).Grid.Mask.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/masks';
Processing(1).Grid.Mask.Name = 'imgAmask3.tif';
% Processing(1).Grid.Mask.Name = 'mask_jet_subregion.tif';
% Processing(1).Grid.Mask.Directory = '';
% Processing(1).Grid.Mask.Name = '';

% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 600;
Processing(1).Frames.Step = 1;

% Correlation parameters
% Processing(1).Correlation.Method = 'apc';
Processing(1).Correlation.Step = 0;
% Processing(1).Correlation.Step = 1;
Processing(1).Correlation.Ensemble.DoEnsemble = false;
Processing(1).Correlation.Ensemble.NumberOfPairs = 10;
Processing(1).Correlation.Ensemble.Domain = 'spectral';
Processing(1).Correlation.Ensemble.Type = 'none';

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
   
   % Grid buffers
   piv_pass.Grid.Buffer.X = region_width_list(p)/2;
   piv_pass.Grid.buffer.Y = region_height_list(p)/2;
   
   % Window
   piv_pass.Window.Fraction = window_fract_list{p};
   
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

% Initialize a job counter
n = 1;

% % % RAW % % % %

% SCC
JobFile.Data.Inputs.Images.BaseName = 'A_';
JobFile.Data.Inputs.Images.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/raw';
JobFile.Data.Inputs.SourceFilePath = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-21/apc/A_raw_apc_ensemble_00001_00600.mat';

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/scc';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_scc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'scc';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end


% RPC
n = n + 1;
% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/rpc';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_rpc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'rpc';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end

% Hybrid
n = n + 1;
% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/hybrid';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_hybrid_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'hybrid';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end


% % % DEGHOST % % % %

% Update where to get the images.
JobFile.Data.Inputs.Images.BaseName = 'A_deghost_';
JobFile.Data.Inputs.Images.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/proc/ghost';
JobFile.Data.Inputs.SourceFilePath = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-21/apc/A_deghost_apc_ensemble_00001_00600.mat';

% Increment the number of jobs
n = n + 1;

JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/scc';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_scc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'scc';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end

% Increment the number of jobs
n = n + 1;

JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/rpc';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_rpc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'rpc';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end

% Increment the number of jobs
n = n + 1;

JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/hybrid';
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_hybrid_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'hybrid';
   JOBLIST(n).Processing(p).Correlation.RPC.EffectiveDiameter = 3;
   JOBLIST(n).Processing(p).Correlation.EstimatedParticleDiameter = 3;
   JOBLIST(n).Processing(p).SubPixel.EstimatedParticleDiameter = 3;
end

end





