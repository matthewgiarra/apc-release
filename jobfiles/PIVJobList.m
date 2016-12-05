function JOBLIST = PIVJobList()

% Number of passes
JobOptions.NumberOfPasses = 0;

% Data: Input images
Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/images/proc/ghost';
% Data.Inputs.Images.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/poiseuille_diffusion_0.00/raw';
Data.Inputs.Images.BaseName = 'A_deghost_';
% Data.Inputs.Images.BaseName = 'poiseuille_diffusion_0.00_';
Data.Inputs.Images.Digits = 5;
Data.Inputs.Images.Extension = '.tif';
Data.Inputs.Images.Trailers = {'_a', '_b'};
% Data.Inputs.Images.Trailers = {''};

% Data: Input vectors for initializing, e.g., image deformation.
Data.Inputs.Vectors.Directory = '';
Data.Inputs.Vectors.BaseName = '';
Data.Inputs.Vectors.Digits = 5;
Data.Inputs.Vectors.Extension = '.mat';

% Data: output vectors
Data.Outputs.Vectors.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/vect';
Data.Outputs.Vectors.BaseName = 'A_deghost_';
Data.Outputs.Vectors.Digits = 5;
Data.Outputs.Vectors.Extension = '.mat';

% Interrogation region dimensions
Processing(1).Region.Height = 64;
Processing(1).Region.Width = 128;
% Processing(1).Region.Height = 128;
% Processing(1).Region.Width = 128;

% Spatial window
Processing(1).Window.Fraction = {[0.25, 0.5], [0.25, 1]};
% Processing(1).Window.Fraction = [0.25, 0.5; 0.25, 1];

% Grid parameters
Processing(1).Grid.Spacing.Y = 64;
Processing(1).Grid.Spacing.X = 64;
Processing(1).Grid.Shift.Y = -16;
% Processing(1).Grid.Shift.Y = 0;
Processing(1).Grid.Shift.X = 0;
Processing(1).Grid.Buffer.Y = 0;
Processing(1).Grid.Buffer.X = 0;
Processing(1).Grid.Mask.Directory = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/images/masks';
Processing(1).Grid.Mask.Name = 'imgAmask3.tif';
% Processing(1).Grid.Mask.Directory = '';
% Processing(1).Grid.Mask.Name = '';


% Frame parameters.
Processing(1).Frames.Start = 1;
Processing(1).Frames.End = 1;
Processing(1).Frames.Step = 1;

% Correlation parameters
Processing(1).Correlation.Method = 'rpc';
Processing(1).Correlation.Step = 0;
% Processing(1).Correlation.Step = 1;
Processing(1).Correlation.Ensemble.DoEnsemble = 1;
Processing(1).Correlation.Ensemble.NumberOfPairs = 1;
Processing(1).Correlation.Ensemble.Domain = 'spatial';

% Parameters specific to APC
Processing(1).Correlation.APC.EnsembleLength = 10;
Processing(1).Correlation.APC.FilterDiameterUpperBound = 6;
Processing(1).Correlation.APC.Shuffle.Range = [0, 0];
Processing(1).Correlation.APC.Shuffle.Step = [0, 0];

% Parameters specific to RPC
Processing(1).Correlation.RPC.EffectiveDiameter = 6;

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
Processing(1).Iterative.Method = 'none';
Processing(1).Iterative.Deform.Interpolation = 'interp2'; 
Processing(1).Iterative.Deform.ConvergenceCriterion = 0.1;
Processing(1).Iterative.Deform.MaxIterations = 1;
Processing(1).Iterative.Source.Directory = '';
Processing(1).Iterative.Source.Name = '';
Processing(1).Iterative.Source.PassNumber = 0;
Processing(1).Iterative.Source.VariableNames.Displacements.X = 'tx_smoothed';
Processing(1).Iterative.Source.VariableNames.Displacements.Y = 'ty_smoothed';
Processing(1).Iterative.Source.VariableNames.Grid.X = 'gy';
Processing(1).Iterative.Source.VariableNames.Grid.Y = 'gx';


% Copy the first processing pass to the second one.
Processing(2) = Processing(1);

Processing(2).Grid.Spacing.Y = 32;
Processing(2).Grid.Spacing.X = 32;

% Add the fields to the jobfile structure.
JobFile.Data = Data;
JobFile.Processing = Processing;
JobFile.JobOptions = JobOptions;

% Append to the job list.
JOBLIST(1) = JobFile;

end



