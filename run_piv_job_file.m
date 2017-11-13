function OUTPUT_FILE_PATH = run_piv_job_file(JOBFILE)

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);

% Check for a field specifying an external file to read
if isfield(JOBFILE.Data.Inputs, 'SourceFilePath')
    
    % Source file path
    source_file_path = JOBFILE.Data.Inputs.SourceFilePath;
    
    % If the file doesn't exist, error and exit.
    if ~exist(source_file_path, 'file')
       fprintf(1, ...
           sprintf('Error:  source file does not exist. Exiting. \n%s\n', ...
           source_file_path));  
    else
        
        % Load the source file
        SourceFile = load(JOBFILE.Data.Inputs.SourceFilePath);
        
        % Put the source file into the job file.
        JOBFILE.Data.Inputs.SourceJobFile = SourceFile.JobFile;
    end    
end
   
% Loop over all the passes.
for p = 1 : num_passes
    % Build list of files to correlate
    
    % Inform the user that the pass is running
    fprintf(1, 'Pass %d of %d\n', p, num_passes);

    % Run the pass. 
    JOBFILE = run_correlation_pass(JOBFILE, p);
    
    % Print a carriage return after the pass compeltes.
    fprintf(1, '\n');

end

% Save the results.
OUTPUT_FILE_PATH = save_piv_jobfile_results(JOBFILE);

end










