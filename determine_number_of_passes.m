function NUMBER_OF_PASSES = determine_number_of_passes(JOBFILE)
% NUMBER_OF_PASSES = determine_number_of_passes(JOBFILE)
% This function determines the number of passes to run 
% for a given PIV job file.

    % Count the number of passes
    num_passes_job_list = length(JOBFILE.Processing);
    
    % Number of passes specified
    num_passes_specified = JOBFILE.JobOptions.NumberOfPasses;
    
    % If the number of passes specified
    % is greater than zero, then use its value
    % to determine how many passes to run.
    if num_passes_specified > 0       
        % Take the number of passes to run
        % as the minimum of the number of processing
        % parameter lists and the number of specified passes.
        NUMBER_OF_PASSES = min(num_passes_specified, num_passes_job_list);
   
    else
        % If the specified number of passes is LEQ 0, 
        % then run all of the passes contained
        % in the job list.
        NUMBER_OF_PASSES = num_passes_job_list;
    end

end