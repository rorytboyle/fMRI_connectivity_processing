% This script reslices fully preprocessed fMRI volumes to the same 
% dimensions as the Shen 268 atlas.nii and then converts the 3D volumes
% into a single 4D timeseries volume. The 4D timeseries volume can then be 
% used for ROI extraction.
% 
% Author: Rory Boyle rorytboyle@gmail.com
% Date: 23/11/2020

%% 1) Prepare directories and files
clear all
tic  % time function

% Enter parent folder
batch_dirs = {'A:\split_timeseries'};

% Get list of all subfolders within parent folder
all_folders = dir(batch_dirs{1});
all_folders = all_folders(3:end);

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
        % add four leading zeros if vol < 10
        if vol < 10
            currentVol = [subject_folder filesep subject ... 
                '_temporally_smoothed_0000' int2str(vol) '.nii,1'];
        end
        % add three leading zeros if vol < 100
        if vol >= 10 && vol < 100
            currentVol = [subject_folder filesep subject ... 
                '_temporally_smoothed_000' int2str(vol) '.nii,1'];
        end
        % add two leading zero if vol >= 100
        if vol >= 100 
            currentVol = [subject_folder filesep subject ... 
                '_temporally_smoothed_00' int2str(vol) '.nii,1'];
        end
        volsToResize = [volsToResize; currentVol];
    end
    
    % set Shen atlas as reference image 
    matlabbatch{1}.spm.spatial.coreg.write.ref = {'A:\shen_2mm_268_parcellation.nii,1'};
    % provide list of preprocessed volumes
    matlabbatch{1}.spm.spatial.coreg.write.source = volsToResize;
    % interpolation with 4th Degree B-Spline - Default setting
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    % No wrapping - Default setting
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    % No masking - Default setting
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    % Prefix resliced 3D volumes with r
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    
%    spm_jobman('run',matlabbatch);

%% 3) Convert resliced fMRI volumes to single 4D timeseries image
    matlabbatch{2}.spm.util.cat.vols(1) = cfg_dep('Coregister: Reslice: Resliced Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    % prepend subid to resized 4D vol
    matlabbatch{2}.spm.util.cat.name = [subject '_4D_temporalSmoothed_Shen.nii'];
    % keep datatype same as original images
    matlabbatch{2}.spm.util.cat.dtype = 0;

%% 4) Run SPM batch
    spm_jobman('run',matlabbatch);
    
    clear matlabbatch
end
toc % get runtime