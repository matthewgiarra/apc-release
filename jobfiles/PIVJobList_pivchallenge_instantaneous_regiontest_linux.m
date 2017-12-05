function JOBLIST = PIVJobList_pivchallenge_instantaneous_regiontest_linux()

% Number of passes to run
num_passes_spec = 1;

% % % Pass parameters
region_width_list  = 32 * (2:7);

% Number of passes
% zero means run all of them.
JobOptions.NumberOfPasses = 0;
JobOptions.StartPass = 1;
JobOptions.Parallel = false;

% Data: Input images
Data.Inputs.Images.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/raw';
Data.Inputs.Images.BaseName = 'A_';
Data.Inputs.Images.Digits = 5;
Data.Inputs.Images.Extension = '.tif';
Data.Inputs.Images.Trailers = {'_a', '_b'};

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

% Spatial window
Processing(1).Window.Fraction = [0.5, 0.5; 0.5, 1];

% Grid parameters
Processing(1).Grid.Spacing.Y = 32;
Processing(1).Grid.Spacing.X = 32;
Processing(1).Grid.Shift.Y = -16;
Processing(1).Grid.Shift.X = 0;
Processing(1).Grid.Buffer.Y = 0;
Processing(1).Grid.Buffer.X = 64;
Processing(1).Grid.Mask.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/masks';
Processing(1).Grid.Mask.Name = 'imgAmask3.tif';

% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 600;
Processing(1).Frames.Step = 1;

% Correlation parameters
Processing(1).Correlation.Step = 0;
Processing(1).Correlation.Ensemble.DoEnsemble = false;
Processing(1).Correlation.Ensemble.NumberOfPairs = 10;
Processing(1).Correlation.Ensemble.Domain = 'spectral';
Processing(1).Correlation.Ensemble.Type = 'none';

% Parameters to specify spectral weighting method (APC, rpc, hybrid, etc)
Processing(1).Correlation.SpectralWeighting.Method = 'hybrid';

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

% Add the fields to the jobfile structure.
JobFile.Data = Data;
JobFile.Processing = Processing;
JobFile.JobOptions = JobOptions;

% Sizes

% Initialize a job counter


% % % RAW % % % %

% APC hybrid
JobFile.Data.Inputs.Images.BaseName = 'A_';
JobFile.Data.Inputs.Images.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/images/raw';
JobFile.Data.Inputs.SourceFilePath = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-21/apc/A_raw_apc_ensemble_00001_00600.mat';
JobFile.Data.Outputs.Vectors.Directory = '/home/shannon/b/aether/piv_test_images/pivchallenge/2014/A/vect_2017-11-26/regiontest';

for n = 1 : length(region_width_list)
    region_width_current = region_width_list(n);
    JOBLIST(n) = JobFile;
    JOBLIST(n).Processing(1).Region.Width = region_width_current; 
    JOBLIST(n).Data.Outputs.Vectors.BaseName = sprintf('%shybrid_regiontest_w%d_', JobFile.Data.Outputs.Vectors.BaseName, region_width_current);
end


end





