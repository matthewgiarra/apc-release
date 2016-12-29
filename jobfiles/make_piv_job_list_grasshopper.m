function JOBLIST = make_piv_job_list_grasshopper()

% List of correlation methods
correlation_method_list = {'scc', 'rpc', 'apc'};

% % Frames list
% Start frame and end frame
start_frame = 1;
end_frame = 600;

% Number of passes
num_passes_spec = 5;

% Image parent directory
image_parent_dir = '/Users/matthewgiarra/Documents/School/VT/Research/Aether/piv_test_images/pivchallenge/2014/A/images/';

% Image directory lists
image_dir_list{1} = fullfile(image_parent_dir, 'raw');
% image_dir_list{2} = fullfile(image_parent_dir, 'proc', 'ghost');

% Image base names
image_base_name_list{1} = 'A_';
% image_base_name_list{2} = 'A_deghost_';

% Number of correlation methods
num_corr_methods = length(correlation_method_list);

% Number of image cases
num_image_cases = length(image_base_name_list);

% Load the default job list
joblist_default = PIVJobList_default;

% Number of passes specified in the job file
num_passes_in_jobfile = determine_number_of_passes(joblist_default(1));

% Results base directory
results_base_dir = fullfile(image_parent_dir, '..', 'vect');

% Initialize the job number
job_num = 0;

% Number of passes in the job file
if num_passes_spec > 0
    num_passes = min(num_passes_spec, num_passes_in_jobfile);
else
    num_passes = num_passes_in_jobfile;
end

% Loop over all the image cases
for k = 1 : num_image_cases

    % Copy the jobfile
    jobfile_current = joblist_default;
    
    % Get rid of unused passes
    jobfile_current.Processing = jobfile_current.Processing(1 : num_passes);
    
    % image directory
    image_dir = image_dir_list{k};
    
    % Image base name
    image_base_name = image_base_name_list{k};
    
    % Update the job file inputs with the current file paths etc
    jobfile_current.Data.Inputs.Images.Directory = image_dir;
    jobfile_current.Data.Inputs.Images.BaseName = image_base_name;

    % Loop over the correlation methods
    for m = 1 : num_corr_methods
        
        % Increment the job numnber
        job_num = job_num + 1;
        
        % Correlation string
        corr_string = correlation_method_list{m};
        
        % Results directory
        results_dir = fullfile(results_base_dir, corr_string);
        
        % Results base name
        results_base_name = sprintf('%s%s_', image_base_name, corr_string);
        
        % Update job file outputs
        jobfile_current.Data.Outputs.Vectors.Directory = results_dir;
        jobfile_current.Data.Outputs.Vectors.BaseName = results_base_name;
        
        % Determine ensemble domain
        switch corr_string
            case 'apc'
                ensemble_domain_string = 'spectral';         
            otherwise
                ensemble_domain_string = 'spatial';
        end
        
        % Loop over the passes
        for p = 1 : num_passes
            
            % Update the correlation method
            jobfile_current.Processing(p).Correlation.Method = corr_string;
            
            % Update the ensemble domain
            jobfile_current.Processing(p).Correlation.Ensemble.Domain = ...
                ensemble_domain_string;
            
            % Update the start and end frames
            jobfile_current.Processing(p).Frames.Start = start_frame;
            jobfile_current.Processing(p).Frames.End = end_frame;
            
        end
        
        % Add this job file to the job list.
        JOBLIST(job_num) = jobfile_current;  
    end    
end

end


