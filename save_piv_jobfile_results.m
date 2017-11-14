function output_file_path = save_piv_jobfile_results(JobFile)

% % Figure out the largest range of frames run
% num_passes = determine_number_of_passes(JOBFILE);
% 
% start_frame = -inf;
% end_frame = inf;
% 
% for p = 1 : num_passes
%     
%     % Check start frame number
%     start_frame_cur = JOBFILE.Processing(p).Frames.Start;
%     start_frame = max(start_frame, start_frame_cur);
%     
%     % Check end frame number
%     end_frame_cur = JOBFILE.Processing(p).Frames.End;
%     end_frame = min(end_frame, end_frame_cur); 
% end
% 
% % Form the output name
% %
% % Number of digits
% num_digits = JOBFILE.Data.Outputs.Vectors.Digits;
% 
% % Digit string for start frame
% start_frame_string = sprintf(sprintf('%%0%dd', num_digits), start_frame);
% end_frame_string   = sprintf(sprintf('%%0%dd', num_digits), end_frame);
% 
% % Output file directory
% output_file_directory = JOBFILE.Data.Outputs.Vectors.Directory;
% 
% % Create the output file directory if it doesn't already exist
% if ~exist(output_file_directory, 'dir')
%     
%     % Inform the user that a jobfile is being created
%     fprintf(1, 'Creating output directory:\n%s\n', output_file_directory);
%     
%     % Create the output directory
%     mkdir(output_file_directory);
%     
% end
% 
% % Output file base name
% output_file_base_name = JOBFILE.Data.Outputs.Vectors.BaseName;
% 
% % Output file extension
% output_file_extension = JOBFILE.Data.Outputs.Vectors.Extension;
% 
% % Output file name
% output_file_name = sprintf('%s%s_%s%s',...
%     output_file_base_name, ...
%     start_frame_string, ...
%     end_frame_string, ...
%     output_file_extension);
% 
% % Save the output file name to the jobfile
% JOBFILE.Data.Outputs.Vectors.FileName = output_file_name;
% 
% % Output file path
% output_file_path = fullfile(output_file_directory, output_file_name);

% Determine the output file path
output_file_path = determine_jobfile_save_path(JobFile);

% Copy the save-file path to the jobfile
JobFile.Data.Outputs.Vectors.Path = output_file_path;

% Save the output file
save(output_file_path, 'JobFile', '-v7.3');

% Inform the user that the file was saved.
if exist(output_file_path, 'file')
    fprintf(1, 'Output file saved to:\n%s\n', output_file_path);
else
    fprintf(1, 'WARNING: OUTPUT FILE NOT SAVED\n');
end

end


