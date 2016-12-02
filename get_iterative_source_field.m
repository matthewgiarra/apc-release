function JOBFILE = get_iterative_source_field(JOBFILE, PASS_NUMBER);

% Assume pass number 1
if nargin < 2
    PASS_NUMBER = 1; 
end

% Handle the iterative procedures that
% don't depend on the specific method 
% of correlation

% If no iterative methods
% are specified, then either
% iterative method can be safely called
% using the already-specified grid
% points with a source field of 
% zeros everywhere. 
% So we can create a "source field"
% of zeros at the already-specified
% grid points here, and then modify 
% it further down if other conditions are met.
gx_source = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.X;
gy_source = JOBFILE.Processing(PASS_NUMBER).Grid.Points.Full.Y;

% Set the source field to zeros
tx_source = zeros(size(gx_source));
ty_source = zeros(size(gy_source));

% Check if the iterative field exists in the jobfile
if isfield(JOBFILE.Processing(PASS_NUMBER), 'Iterative');

    % Check which iterative method is specified
    iterative_method = lower(JOBFILE.Processing(PASS_NUMBER).Iterative.Method);

    % If this is the first pass, and an iterative
    % method was specified, then search for the 
    % source displacement field.
    % The "isempty" line says "if the string "no" does not
    % appear in the iterative method specification string..."
    % This should cover specifiying the iterative
    % method as, e.g., "None" or "no"
    if isempty(regexpi(iterative_method, 'no'));
        
        % If For pass numbers greater than 1,
        % default to taking the previous pass results.
        if PASS_NUMBER > 1
           
            % Extract the previous pass data
            previous_pass_struct = JOBFILE.Processing(PASS_NUMBER - 1);

            % Default to taking the grid 
            % points from the previous pass.
            gx_source = previous_pass_struct.Grid.Points.Full.X;
            gy_source = previous_pass_struct.Grid.Points.Full.Y;

            % Default to taking the smoothed
            % displacements from the previous pass.
            if isfield(previous_pass_struct, 'Results')
                tx_source = previous_pass_struct.Results.Displacements.X.Smoothed;
                ty_source = previous_pass_struct.Results.Displacements.Y.Smoothed;        
            end            
        end

        % Check whether the "Source" field exists
        if isfield(JOBFILE.Processing(PASS_NUMBER).Iterative, 'Source')

            % IF the "source" field exists, extract it.
            iterative_source_field = JOBFILE.Processing(PASS_NUMBER).Iterative.Source;

            % Check whether the fields for the directory
            % and name of the source files exist.
            if isfield(iterative_source_field, 'Directory')
                % Read the name of the directory that
                % is supposed to contain the source file.
                velocity_source_file_dir = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Directory;
            else
                % Default to an empty string
                velocity_source_file_dir = '';
            end

            % Check whether the "file name" field exists for the source field
            if isfield(iterative_source_field, 'Name')
                % Read the name of the file that is 
                % supposed to contain the source data.
                velocity_source_file_name = JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Name;
            else
                % Default to an empty string
                velocity_source_file_name = '';
            end

            % Make sure these both aren't empty
            % load_source_field_flag is a boolean
            % that specifies whether to load the files.
            source_field_specified_flag = ~isempty(velocity_source_file_dir) && ...
                ~isempty(velocity_source_file_name);

            % Load the source data if these conditions 
            % have all been satisified
            % (source field is requested AND source field file exists)
            if source_field_specified_flag == true

                % Construct the file path
                source_field_path = fullfile(velocity_source_file_dir, ...
                    velocity_source_file_name);

                % Flag specifying whether the source field exists.
                source_field_exists_flag = exist(source_field_path, 'file'); 
            else
                % Default to no source field
                source_field_exists_flag = false; 
            end

            % This block loads the source field file.
            if source_field_exists_flag == true

                % Load the source field
                load(source_field_exists_flag);

                % Read the variable names that we need to load
                %
                % Displacement variable names
                tx_source_var_name_str = iterative_source_field.Source.VariableNames.Displacements.X;
                ty_source_var_name_str = iterative_source_field.Source.VariableNames.Displacements.Y;
                %
                % Grid variable names
                gx_source_var_name_str = iterative_source_field.Source.VariableNames.Grid.X;
                gy_source_var_name_str = iterative_source_field.Source.VariableNames.Grid.Y;

                % Extract the variables
                eval(sprintf('tx_source = %s', tx_source_var_name_str));
                eval(sprintf('ty_source = %s', ty_source_var_name_str));
                eval(sprintf('gx_source = %s', gx_source_var_name_str));
                eval(sprintf('gy_source = %s', gy_source_var_name_str));

            end     
        end       
    end   
end

% Append the source variables to the job file.
JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.X = tx_source;
JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Displacement.Y = ty_source;
JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.X = gx_source;
JOBFILE.Processing(PASS_NUMBER).Iterative.Source.Grid.Y = gy_source;

end

