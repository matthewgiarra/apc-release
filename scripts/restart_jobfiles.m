

start_pass = 6;

dstJobFile = '/Users/matthewgiarra/Desktop/apc/compare_thresholds/A_raw_apc_ensemble_rpcd_3_no_min_00001_00600';
srcJobList = PIVJobList_pivchallenge_ensemble_multi_job;
srcJobFile = srcJobList(1);
dstJobFile = copy_jobfile_paths(srcJobFile, dstJobFile);

dstJobFile.Processing(start_pass).Correlation.SpectralWeighting.APC.Thresh.X = [0, inf];
dstJobFile.Processing(start_pass).Correlation.SpectralWeighting.APC.Thresh.Y = [0, inf];

% Update the start pass
dstJobFile.JobOptions.StartPass = start_pass;

% remove the source jobfile field
new_inputs = rmfield(dstJobFile.Data.Inputs, 'SourceFilePath');
dstJobFile.Data.Inputs = new_inputs;

% Run the job
run_piv_job_list(dstJobFile);
