%% A
clc;clear all;close all
ADir = 'D:\FC\demo\example_datasets1\Data_AVSP_20\A';
DirA = dir(fullfile(ADir,'*.set'));  
FileNamesA = {DirA.name};

for f = 1:numel(FileNamesA)  
    EEG = pop_loadset('filename',FileNamesA{1,f},'filepath',ADir);
    EEG = eeg_checkset( EEG ); 
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, 'filename',FileNamesA{1,f},'filepath',...
          'D:\FC\demo\eventEEG_analysis\data_250Hz\A');
end
%% L
clc;clear all;close all
LDir = 'D:\FC\demo\example_datasets1\Data_AVSP_20\L';
DirL = dir(fullfile(LDir,'*.set'));  
FileNamesL = {DirL.name};

for f = 1:numel(FileNamesL)  
    EEG = pop_loadset('filename',FileNamesL{1,f},'filepath',LDir);
    EEG = eeg_checkset( EEG ); 
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, 'filename',FileNamesL{1,f},'filepath',...
          'D:\FC\demo\eventEEG_analysis\data_250Hz\L');
end
%% S
clc;clear all;close all
SDir = 'D:\FC\demo\example_datasets1\Data_AVSP_20\S';
DirS = dir(fullfile(SDir,'*.set'));  
FileNamesS = {DirS.name};

for f = 1:numel(FileNamesS)  
    EEG = pop_loadset('filename',FileNamesS{1,f},'filepath',SDir);
    EEG = eeg_checkset( EEG ); 
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, 'filename',FileNamesS{1,f},'filepath',...
          'D:\FC\demo\eventEEG_analysis\data_250Hz\S');
end
%% V
clc;clear all;close all
VDir = 'D:\FC\demo\example_datasets1\Data_AVSP_20\V';
DirV = dir(fullfile(VDir,'*.set'));  
FileNamesV = {DirV.name};

for f = 1:numel(FileNamesV)  
    EEG = pop_loadset('filename',FileNamesV{1,f},'filepath',VDir);
    EEG = eeg_checkset( EEG ); 
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, 'filename',FileNamesV{1,f},'filepath',...
          'D:\FC\demo\eventEEG_analysis\data_250Hz\V');
end
