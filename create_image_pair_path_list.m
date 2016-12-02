function JOBFILE = create_image_pair_path_list(JOBFILE, PASS_NUMBER)

    % Do everything that doesn't change with
    % the number of passes
    input_image_directory = JOBFILE.Data.Inputs.Images.Directory;
    
    % Input image base name
    input_image_base_name = JOBFILE.Data.Inputs.Images.BaseName;
    input_image_num_digits = JOBFILE.Data.Inputs.Images.Digits;
    input_image_file_extension = JOBFILE.Data.Inputs.Images.Extension;
    
    % Create the string format for the images
    number_format = sprintf('%%0%dd', input_image_num_digits);
    
    % Determine the image trailers
    [input_image_trailer_01, input_image_trailer_02] = ...
        determine_image_trailers(JOBFILE);
    
    % Extract the Processing parameters
    proccessing_params = JOBFILE.Processing(PASS_NUMBER);
    
    % Start frame
    frame_start = proccessing_params.Frames.Start;
    
    % End frame
    frame_end = proccessing_params.Frames.End;
    
    % Frame step
    frame_step = proccessing_params.Frames.Step;
    
    % Correlation step
    correlation_step = proccessing_params.Correlation.Step;
    
    % Create the list of image numbers for
    % the first frame in each pair.
    image_numbers_01 = frame_start : frame_step : frame_end;
    
    % Create the list of image numbers for
    % the second frame in each pair.
    image_numbers_02 = image_numbers_01 + correlation_step;
    
    % Count the number of pairs
    num_pairs = length(image_numbers_01);
    
    % Loop over the pairs
    for pair_number = 1 :  num_pairs
        
        % Numbers of the images
        num_str_01 = sprintf(sprintf('%s', number_format), image_numbers_01(pair_number));
        num_str_02 = sprintf(sprintf('%s', number_format), image_numbers_02(pair_number));
        
        % Name of the first image;
        image_name_01 = sprintf('%s%s%s%s', ...
            input_image_base_name,...
            num_str_01,...
            input_image_trailer_01,...
            input_image_file_extension);
            
        % Name of the first image;
        image_name_02 = sprintf('%s%s%s%s', ...
            input_image_base_name,...
            num_str_02,...
            input_image_trailer_02,...
            input_image_file_extension);
        
        % Construct file paths
        file_list_01{pair_number} = fullfile(input_image_directory, image_name_01);
        file_list_02{pair_number} = fullfile(input_image_directory, image_name_02);
       
    end % END (while pair_number <= num_pairs)
    
    % Add the list of files to the jobfile
    JOBFILE.Processing(PASS_NUMBER).Frames.Paths{1} = file_list_01;
    JOBFILE.Processing(PASS_NUMBER).Frames.Paths{2} = file_list_02;
    
end % END OF FUNCTION








