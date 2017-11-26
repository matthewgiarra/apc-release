function output_file_path = save_piv_jobfile_results(JobFile, verbose)

if nargin < 2
    verbose = false;
end

% Determine the output file path
output_file_path = determine_jobfile_save_path(JobFile);

% Copy the save-file path to the jobfile
JobFile.Data.Outputs.Vectors.Path = output_file_path;

% Save the output file
save(output_file_path, 'JobFile', '-v7.3');

% Inform the user that the file was saved.
if exist(output_file_path, 'file')
    if verbose == true
        fprintf(1, 'Output file saved to:\n%s\n', output_file_path);
    end
else
    fprintf(1, 'WARNING: OUTPUT FILE NOT SAVED\n');
end

end


