%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------FMRIPREP2BV-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ______________________________________________________________________
% |                                                                      |%
% |                                                                      |%
% |                           Example script                             |%
% |                                V0.1                                  |%
% |______________________________________________________________________|%
%
%
% Info
%
%
% Requirements:
% - Neuroelf v1.1 in matpab path (https://neuroelf.net/)
%

clear, clc

% A set of neuroelf functions from its private folder
% This includes importvtcfromanalyze()
addpath('func-neuroelf')

%% Settings
% Processed data folder 
dataFolder = 'example-data';

% Subject ID
subjectID = '01';

% Reference Space
% 3 - TAL, 4 - MNI
rSpace = 4;

% Resolution time (in milliseconds)
tr = 1000;

% Spatial Resolution (units are anat image voxels)
% Example:
% anat image with 1x1x1 mm, func image with 2x2x2 mm --> res = 2
% anat image with 1x1x1 mm, func image with 3x3x3 mm --> res = 3
res = 2;

%% Do it

% Find files in dataFolder
D = dir(fullfile(dataFolder,['sub-' subjectID '*desc-preproc_bold.nii.gz']));

% Iterate on the func files
for fileIDX = 1:length(D)

    % Load VTC
    vtc = importvtcfromanalyze({fullfile(D(fileIDX).folder,D(fileIDX).name)},[],res);

    % Change reference space
    vtc.ReferenceSpace = rSpace;
    
    % Change TR
    vtc.TR = tr;
    
    % Find run id
    aux = strsplit(D(fileIDX).name,'_');
    
    % Add .prt (needs to be in the same folder of the func)
    vtc.NameOfLinkedPRT = 'protocol-example.prt'; 

    % Save VTC
    vtc.SaveAs(fullfile(dataFolder,[D(fileIDX).name(1:end-7) '.vtc']));
    
    % Close VTC
    vtc.ClearObject;

    % Print
    fprintf('saved func file %i \n',fileIDX);
    
end
