% This script converts fully preprocessed 3D fMRI volumes into a single 4D 
% timeseries volume.
% 
% Author: Rory Boyle rorytboyle@gmail.com
% Date: 19/11/2020

%% 1) Prepare directories and files
clear all
tic  % time function

% Enter batch folders
batch_dirs = {'A:\batch1_preprocessed', 'A:\batch2_preprocessed',...
              'A:\batch3_preprocessed', 'A:\batch4_preprocessed',...
              'A:\batch5_preprocessed'};

% Get list of all subfolders within first batch folder
all_folders = dir(batch_dirs{1});
all_folders = all_folders(3:end);

% Loop through remaining batch folders and add to all_folders
for batch = 2:length(batch_dirs)  % already added first batch
    currentFolder = dir(batch_dirs{batch});
    currentFolder = currentFolder(3:end);
    all_folders = [all_folders; currentFolder];
end

%% 2) Convert 3D fMRI volumes to single 4D timeseries image
% loop through each subject folder, get preprocessed fMRI volumes, and
% convert to 4D image
for i=1:length(all_folders)
    
    % Get subject folder
    subject_folder = [all_folders(i).folder filesep all_folders(i).name];
    
    % Get subject id
    subject = all_folders(i).name;
    
    % Create list of preprocessed volumes
    vols_to_convert = {};
    num_vols = 200  % ENTER NUMBER OF PREPROCESSED VOLUMES FOR EACH PPT
    for vol = 1:num_vols
        % add three leading zeros if vol < 10
        if vol < 10
            currentVol = [subject_folder filesep 'Res_000' int2str(vol) '.nii,1'];
        end
        % add two leading zeros if vol < 100
        if vol >= 10 && vol < 100
            currentVol = [subject_folder filesep 'Res_00' int2str(vol) '.nii,1'];
        end
        % add one leading zero if vol >= 100
        if vol >= 100 
            currentVol = [subject_folder filesep 'Res_0' int2str(vol) '.nii,1'];
        end
        vols_to_convert = [vols_to_convert; currentVol];    
    end
 
    try
        matlabbatch{1}.spm.util.cat.vols = vols_to_convert;
        % prepend subid to resized 4D vol
        matlabbatch{1}.spm.util.cat.name = [subject '_4D_timeseries.nii'];
        % keep datatype same as original images
        matlabbatch{1}.spm.util.cat.dtype = 0;

%% 4) Run SPM batch
    spm_jobman('run',matlabbatch);
    catch 
        disp('Error using MATLABbatch system - file likely does not exist')
    end
    clear matlabbatch
end
toc % get runtime