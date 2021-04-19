%% Clear and add paths
clear,clc
addpath('Neuroelf_functions')

%% Settings
% Processed data folder Path 
datafolder = '...\MRI_EDHC\PROCESSED';

% Protocol folder
prtfolder = '...\MRI_EDHC\PRTs';

% Subject ID
subjectid = '14';

% Functional data folder (nii files)
funcfolder = fullfile(datafolder,['sub-' subjectid], 'ses-01', 'func');

% Output folder (to export .vtc)
outputfolder = fullfile(datafolder,'derivatives',['sub-' subjectid],'ses-01', 'func');

% Create outputfolder if not exist
if ~exist(outputfolder,'dir')
    mkdir(outputfolder)
end

%% Do it

% Find files in funcfolder
d = dir(fullfile(funcfolder,'*.nii.gz'));

% Iterate on the func files
for fileid = 1:7

    % Load VTC
    vtc = importvtcfromanalyze({fullfile(funcfolder,d(fileid).name)},[],2);

    % Change referecen space to MNI
    vtc.ReferenceSpace = 4;
    
    % Change TR
    vtc.TR = 1000;
    
    % Find run id
    aux = strsplit(d(fileid).name,'_');
    
    % only for task functional runs
    if strcmp(aux{3},'task-main')
        runid = aux{5}(end);
        
        % copy prt to func folder - BV is dumb
        copyfile(fullfile(prtfolder,['MRITask-Run0' runid '.prt']),...
                 fullfile(outputfolder,['MRITask-Run0' runid '.prt']) );
        
        % Add .prt
        vtc.NameOfLinkedPRT = ['MRITask-Run0' runid '.prt']; 
    end
    
    % Save VTC
    vtc.SaveAs(fullfile(outputfolder,[d(fileid).name(1:end-7) '.vtc']));
    
    % Close VTC
    vtc.ClearObject;

    % Print
    fprintf('saved func file %i \n',fileid);
    
end
