function JOBFILE = run_piv_job_file(JOBFILE)

% Determine the number of passes to run.
num_passes = determine_number_of_passes(JOBFILE);
   
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
   
end










