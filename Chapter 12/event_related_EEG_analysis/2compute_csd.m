clc;clear all;close all
EEG = pop_loadset('filename','1_A.set','filepath','D:\FC\demo\eventEEG_analysis\data_250Hz\A\');
EEG = eeg_checkset( EEG );
for site = 1:size(EEG.data,1)
    electrodes{site}=(EEG.chanlocs(site).labels);
end;
electrodes = electrodes';
%% Get Montage for use with CSD Toolbox
Montage = ExtractMontage('10-5-System_Mastoids_EGI129.csd',electrodes);
%% Derive G and H!
[G,H] = GetGH(Montage);
%% Save G and H to later import when doing the CSD transform on files
% revised method to store G and H matrices with CSD montage for later import                     
% save CSDmontage.mat G H Montage;
%% A 
DataDir = 'D:\FC\demo\eventEEG_analysis\data_250Hz\A\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for f = 1:length(filename)
    EEG = pop_loadset('filename',filename{1,f},'filepath',DataDir);
    EEG = eeg_checkset( EEG );    
    %
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',filename{1,f},'filepath',...
    'D:\FC\demo\eventEEG_analysis\ps_csd\csd\A');
    %
    clear i EEG D X CSDdata
end
%% L 
DataDir = 'D:\FC\demo\eventEEG_analysis\data_250Hz\L\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for f = 1:length(filename)
    EEG = pop_loadset('filename',filename{1,f},'filepath',DataDir);
    EEG = eeg_checkset( EEG );    
    %
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',filename{1,f},'filepath',...
    'D:\FC\demo\eventEEG_analysis\ps_csd\csd\L');
    %
    clear i EEG D X CSDdata
end
%% S 
DataDir = 'D:\FC\demo\eventEEG_analysis\data_250Hz\S\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for f = 1:length(filename)
    EEG = pop_loadset('filename',filename{1,f},'filepath',DataDir);
    EEG = eeg_checkset( EEG );    
    %
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',filename{1,f},'filepath',...
    'D:\FC\demo\eventEEG_analysis\ps_csd\csd\S');
    %
    clear i EEG D X CSDdata
end
%% V 
DataDir = 'D:\FC\demo\eventEEG_analysis\data_250Hz\V\';
DirData = dir(fullfile(DataDir,'*.set'));  
filename = {DirData.name};

for f = 1:length(filename)
    EEG = pop_loadset('filename',filename{1,f},'filepath',DataDir);
    EEG = eeg_checkset( EEG );    
    %
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',filename{1,f},'filepath',...
    'D:\FC\demo\eventEEG_analysis\ps_csd\csd\V');
    %
    clear i EEG D X CSDdata
end







