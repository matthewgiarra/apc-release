function JOBLIST = PIVJobList_pivchallenge_from_source_multi_job()

% Number of passes to run
num_passes_spec = 6;

% % Pass parameters
region_height_list_raw = [64,  64,  64, 32, 32, 32, 32];
region_width_list_raw  = [128, 128, 64, 32, 32, 32, 32];
window_fract_list_raw = {[0.5, 0.5; 0.5, 1], 0.5, 0.5, 1.0, 24/32, 24/32, 24/32};
grid_spacing_list_raw = [32, 32, 32, 16, 16, 16, 2];
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

% Data: Input images
% Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/proc/ghost';
Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/raw';
% Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/poiseuille_diffusion_0.00/raw';
% Data.Inputs.Images.BaseName = 'A_deghost_';
Data.Inputs.Images.BaseName = 'A_';
% Data.Inputs.Images.BaseName = 'poiseuille_diffusion_0.00_';
Data.Inputs.Images.Digits = 5;
Data.Inputs.Images.Extension = '.tif';
Data.Inputs.Images.Trailers = {'_a', '_b'};
% Data.Inputs.Images.Trailers = {''};


% Data: Input vectors for initializing, e.g., image deformation.
Data.Inputs.Vectors.Directory = '/Users/matthewgiarra/Desktop/apc';
Data.Inputs.Vectors.BaseName = 'A_deghost_';
Data.Inputs.Vectors.Digits = 5;
Data.Inputs.Vectors.Extension = '.mat';

% Source file path
% Data.Inputs.SourceFilePath = '/Users/matthewgiarra/Desktop/apc/A_deghost_apc_00001_00600.mat';
Data.Inputs.SourceFilePath = '/Users/matthewgiarra/Desktop/apc/A_apc_00001_00600.mat';

% Data: output vectors
Data.Outputs.Vectors.Directory = '/Users/matthewgiarra/Desktop/piv_test_images/pivchallenge/2014/A/vect/test_rpc_diameter_6';
% Data.Outputs.Vectors.BaseName = 'A_deghost_from_source_';
Data.Outputs.Vectors.BaseName = 'A_raw_from_source_';
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
Processing(1).Grid.Mask.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/masks';
Processing(1).Grid.Mask.Name = 'imgAmask3.tif';
% Processing(1).Grid.Mask.Name = 'mask_jet_subregion.tif';
% Processing(1).Grid.Mask.Directory = '';
% Processing(1).Grid.Mask.Name = '';

% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 1;
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
Processing(1).Correlation.SpectralWeighting.Method = 'scc';

% Parameters specific to APC
Processing(1).Correlation.SpectralWeighting.APC.FilterDiameterUpperBound = 6;
Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Range = [0, 0];
Processing(1).Correlation.SpectralWeighting.APC.Shuffle.Step = [0, 0];
Processing(1).Correlation.SpectralWeighting.APC.Thresh.X = [0, inf];
Processing(1).Correlation.SpectralWeighting.APC.Thresh.Y = [0, inf];
Processing(1).Correlation.SpectralWeighting.APC.Method = 'magnitude';

Processing(1).Correlation.DisplacementEstimate.Domain = 'spatial';

% Parameters specific to RPC
Processing(1).Correlation.RPC.EffectiveDiameter = 6;

% Estimated particle diameter
Processing(1).Correlation.EstimatedParticleDiameter = 6;

% Subpixel fit parameters
Processing(1).SubPixel.Method = '3-point fit';
Processing(1).SubPixel.EstimatedParticleDiameter = 6;

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

% Start the job counter
n = 0;


% Update where to get the images.
JobFile.Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/raw';
JobFile.Data.Inputs.Images.BaseName = 'A_';
JobFile.Data.Inputs.SourceFilePath = '/Users/matthewgiarra/Desktop/apc/fine_grid/A_raw_apc_ensemble_rpcd_3_no_min_ac_00001_00600.mat';

% Count the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_instantaneous_apc_hybrid_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'hybrid';
end

% Increment the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_instantaneous_rpc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'rpc';
end

% Increment the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_raw_instantaneous_scc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'scc';
end


% Update where to get the images.
JobFile.Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/data/piv/piv_challenge/2014/A/images/proc/ghost';
JobFile.Data.Inputs.Images.BaseName = 'A_deghost_';
JobFile.Data.Inputs.SourceFilePath = '/Users/matthewgiarra/Desktop/apc/fine_grid/A_deghost_apc_ensemble_rpcd_3_no_min_ac_00001_00600.mat';
JobFile.Data.Outputs.Vectors.BaseName = 'A_deghost_instantaneous_apc_hybrid_';


% Increment the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_instantaneous_apc_hybrid_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'hybrid';
end

% Increment the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_instantaneous_rpc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'rpc';
end

% Increment the number of jobs
n = n + 1;

% Append to the job list.
JOBLIST(n) = JobFile;
JOBLIST(n).Data.Outputs.Vectors.BaseName = 'A_deghost_instantaneous_scc_';
for p = 1 : num_passes_total
   JOBLIST(n).Processing(p).Correlation.SpectralWeighting.Method = 'scc';
end



end



