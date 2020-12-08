% This script splits fully preprocessed 4D fMRI timeseries fMRI into
% separate 3D volumes so that they can then be resliced to parcellation
% atlas before ROI extraction. 
% Images must first be gunzipped, i.e. must be .nii files not .nii.gz files
% 
% Author: Rory Boyle rorytboyle@gmail.com
% Date: 23/11/2020

% Read in all images and get full file names
files = dir('A:\to_convert_unzipped');
files = files(3:end);

% Loop through images
for i =1:length(files)
    % get file name
    ppt_file = [files(i).folder filesep files(i).name];
    
    % Create subdir
    subid = files(i).name(1:7);
    subdir = ['A:\split_timeseries' filesep subid]; % have to separate this
 	mkdir(subdir)                                   % line and this line
                                                    % because assigning
                                                    % mkdir to a var
                                                    % returns a logical NOT
                                                    % the name of subdir
    % Split file
    spm_file_split(ppt_file, subdir)
end