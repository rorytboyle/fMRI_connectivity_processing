% This script reslices fully preprocessed fMRI volumes to the same 
% dimensions as the Shen 268 atlas.nii and then converts the 3D volumes
% into a single 4D timeseries volume. The 4D timeseries volume can then be 
% used for ROI extraction.
% 
% Author: Rory Boyle rorytboyle@gmail.com
% Date: 07/05/2020

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

%% 2) Reslice preprocessed fMRI volumes to reference image
% loop through each subject folder, get preprocessed fMRI volumes, resize
% and convert to 4D image
for i=1:length(all_folders) 
    
    % Get subject folder
    subject_folder = [all_folders(i).folder filesep all_folders(i).name];
    
    % Get subject id
    subject = all_folders(i).name;
    
    % Create list of preprocessed volumes
    volsToResize = {};
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
        volsToResize = [volsToResize; currentVol];
    end
    
    % set Shen atlas as reference image ADD PROPER REFERENCE TO SHEN ATLAS
    matlabbatch{1}.spm.spatial.coreg.write.ref = {'A:\extractionTest\shen_2mm_268_parcellation.nii,1'};
    % provide list of preprocessed volumes
    matlabbatch{1}.spm.spatial.coreg.write.source = volsToResize;
    % interpolation with 4th Degree B-Spline 
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    % No wrapping
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    % No masking
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    % Prefix resliced 3D volumes with r
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    
%% 3) Convert resliced fMRI volumes to single 4D timeseries image
    matlabbatch{2}.spm.util.cat.vols(1) = cfg_dep('Coregister: Reslice: Resliced Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    % prepend subid to resized 4D vol
    matlabbatch{2}.spm.util.cat.name = [subject '_4D_timeseries.nii'];
    % keep datatype same as original images
    matlabbatch{2}.spm.util.cat.dtype = 0;

%% 4) Run SPM batch
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end