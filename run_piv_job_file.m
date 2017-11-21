function [OUTPUT_FILE_PATH, JOBFILE] = run_piv_job_file(JOBFILE)

% Starting pass
start_pass = JOBFILE.JobOptions.StartPass;

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);

% Check for a field specifying an external file to read
if isfield(JOBFILE.Data.Inputs, 'SourceFilePath')
    
    % Source file path
    source_file_path = JOBFILE.Data.Inputs.SourceFilePath;
    
    % If the file doesn't exist, error and exit.
    if ~exist(source_file_path, 'file')
       fprintf(1, ...
           sprintf('Warning:  source file does not exist. \n%s\n', ...
           source_file_path));  
    else
        
        % Load the source file
        SourceFile = load(JOBFILE.Data.Inputs.SourceFilePath);
        
        % Put the source file into the job file.
        JOBFILE.Data.Inputs.SourceJobFile = SourceFile.JobFile;
    end    
end
   
% Loop over all the passes.
for p = start_pass : num_passes
    % Build list of files to correlate
    
    % Inform the user that the pass is running
    fprintf(1, 'Pass %d of %d\n', p, num_passes);

    % Check whether ensemble is happening
    do_ensemble = JOBFILE.Processing(p).Correlation.Ensemble.DoEnsemble;
    
    if do_ensemble
        JOBFILE = run_correlation_pass_parallel(JOBFILE, p);
    else
         JOBFILE = run_correlation_pass(JOBFILE, p);
    end

    % Save the results
    save_piv_jobfile_results(JOBFILE);
    
    % Print a carriage return after the pass compeltes.
    fprintf(1, '\n');

end

% Save the results.
OUTPUT_FILE_PATH = save_piv_jobfile_results(JOBFILE, true);

end










