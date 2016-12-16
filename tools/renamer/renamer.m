function[] = renamer(FILEDIR, OLDBASENAME, NEWBASENAME, NDIGITS, OLDTRAILER, NEWTRAILER, OLD_EXTENSION, NEW_EXTENSION, START, STOP)
% RENAMER changes the names of a series of files. This function does not
% write any outputs to the MATLAB workspace.
% 
% Syntax
%   renamer(IMDIR, OLDSERIES, NEWSERIES, NDIGITS, OLDTRAILER, NEWTRAILER, EXTENSION, START, STOP)
% 
% Description
%   Renamer looks for a series of files whose names are numerically ordered
%   (i.e., File_0001.jpg, File_0002.jpg, etc.) and renames them while
%   preserving the numerical ordering of the filenames (i.e.,
%   newName_0001.jpg, newName_0002.jpg).
% 
% Inputs
%   FILEDIR: Directory containing files to be renamed, including a trailng slash (string)
% 
%   OLDBASENAME: Original base name of files to be renamed, including a trailing slash. For files named 'File_0001.jpg', etc, OLDBASENAME would be 'File_' (string)
% 
%   NEWBASENAME: New base name of files (string)
% 
%   NDIGITS: Number of digits following the basenames of the raw images (integer)
% 
%   OLDTRAILER: Text in the original filenames that occurs after the
%   numbering but before the file extension (string).
%   For files named 'File_0001_old.jpg', OLDTRAILER would be '_old' . Set
%   OLDTRAILER as an empty string (i.e., OLDTRAILER = '') if the filenames do not contain a trailer. 
% 
%   NEWTRAILER: Text in the renamed filenames that occurs after the
%   numbering but before the file extension (string).
% 
%   EXTENSION: File extension of the files to be renamed (string). 
% 
%   START: Number of the first image in the series of raw images (integer)
% 
%   STOP: Number of the last image in the series of raw images (integer)
% 
% Outputs
%   None.
% 
% Example
% FILEDIR =  '~/Desktop/TESTDIR/';
% OLDBASENAME = 'testfile_';
% NEWBASENAME = 'renamed_';
% NDIGITS = 4;
% OLDTRAILER = '';
% NEWTRAILER = '';
% EXTENSION = '.rtf';
% START = 1;
% STOP = 3;
% renamer(FILEDIR, OLDBASENAME, NEWBASENAME, NDIGITS, OLDTRAILER, NEWTRAILER, EXTENSION, START, STOP);

% BEGIN FUNCTION

% Format sprintf argument for specified number of zeros
form = ['%0' num2str(NDIGITS) '.0f'];

% Number of images
depth = STOP - START + 1;

% Initialize wait bar
h = waitbar(0, 'Renaming images...');

% Create array of strings containing file names
for i = 1: depth
        oldfilepath = fullfile(FILEDIR, [OLDBASENAME sprintf(form, START + i - 1) OLDTRAILER OLD_EXTENSION]);
        newfilepath = fullfile(FILEDIR, [NEWBASENAME sprintf(form, START + i - 1) NEWTRAILER NEW_EXTENSION]);
    
%  Update wait bar
        waitbar(i/depth);
    
%  Rename files
    movefile(oldfilepath, newfilepath);
        
end

% Close wait bar
close(h);



end


% END FUNCTION
