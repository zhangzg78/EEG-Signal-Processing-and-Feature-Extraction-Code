clc;clear all;close all
EEG = pop_loadset('filename','sub01c.set','filepath',...
'D:\FC\demo\example_datasets2\restEEG\EC\');
EEG = pop_select( EEG,'nochannel',{'TP9' 'TP10'});
EEG = pop_reref( EEG, []);
EEG = eeg_checkset( EEG );
electrodes = {EEG.chanlocs.labels}';
%% Get Montage for use with CSD Toolbox
Montage = ExtractMontage('10-5-System_Mastoids_EGI129.csd',electrodes);
%% Derive G and H!
[G,H] = GetGH(Montage);
%% Save G and H to later import when doing the CSD transform on files
% revised method to store G and H matrices with CSD montage for later import                     
% save CSDmontage.mat G H Montage;
%%
ECDir = 'D:\FC\demo\example_datasets2\restEEG\EC';
EODir = 'D:\FC\demo\example_datasets2\restEEG\EO';

DirEC = dir(fullfile(ECDir,'*.set'));  %%%% find all the *.set file in 'ECDir'
DirEO = dir(fullfile(EODir,'*.set'));

FileNamesEC = {DirEC.name};
FileNamesEO = {DirEO.name};

for f = 1:numel(FileNamesEC)  
    EEG = pop_loadset('filename'FileNamesEC{1,f},'filepath',ECDir);
    EEG = eeg_checkset( EEG );   
    EEG = pop_select( EEG,'nochannel',{'TP9' 'TP10'});
    EEG = pop_reref( EEG, []);
    EEG = eeg_checkset( EEG );
    %%%
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',FileNamesEC{1,f},'filepath','D:\FC\demo\restEEG_analysis\csd\EC');
    clear i EEG D X CSDdata
end

for f = 1:numel(FileNamesEO)  
    EEG = pop_loadset('filename',FileNamesEO{1,f},'filepath',EODir);
    EEG = eeg_checkset( EEG ); 
    EEG = pop_select( EEG,'nochannel',{'TP9' 'TP10'});
    EEG = pop_reref( EEG, []);
    EEG = eeg_checkset( EEG );
    %%%
    for i = 1:size(EEG.data,3)
        D = squeeze(EEG.data(:,:,i));
        X = CSD (D, G, H);
        CSDdata(:,:,i) = X;
    end
    EEG.data = CSDdata;
    EEG = eeg_checkset( EEG );    
    EEG = pop_saveset(EEG,'filename',FileNamesEO{1,f},'filepath','D:\FC\demo\restEEG_analysis\csd\EO');
    clear i EEG D X CSDdata
end


