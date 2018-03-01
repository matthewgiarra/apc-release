function [OUTPUT_FILE_PATH, JOBFILE] = run_piv_job_file(JOBFILE)

% Starting pass
start_pass = JOBFILE.JobOptions.StartPass;

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);

% Check for a field specifying an external file to read
if isfield(JOBFILE.Data.Inputs, 'SourceFilePath')
    
  % Source file path
    source_file_path = JOBFILE.Data.Inputs.SourceFilePath;
    
    % Check if it's empty
    if ~isempty(source_file_path)
    
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
end
   
% Loop over all the passes.
for p = start_pass : num_passes
    
    % Inform the user that the pass is running
    fprintf(1, 'Pass %d of %d\n', p, num_passes);

    % Check whether ensemble is happening
    do_ensemble = JOBFILE.Processing(p).Correlation.Ensemble.DoEnsemble;
    
    % Determine whether or not to run the pass with parallel processing
    if do_ensemble
        % Set the job pass in parallel if we're doing ensemble
        JOBFILE.JobOptions.Parallel = true;
    else
        % Dont run the pass in parallel if we aren't doing
        % ensemble, because in this case we'll probably
        % run the entire job in parallel. 
        JOBFILE.JobOptions.Parallel = false;
    end
    
    % Run the pass
    JOBFILE = run_correlation_pass(JOBFILE, p);

    % Save the results
    save_piv_jobfile_results(JOBFILE);
    
    % Print a carriage return after the pass compeltes.
    fprintf(1, '\n');

end

% Save the results.
OUTPUT_FILE_PATH = save_piv_jobfile_results(JOBFILE, true);

end










