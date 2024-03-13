%% PLV
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLV\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    plv_alls_L_c3c4(:,:,i) = squeeze(plv(:,:,44,15));
end
plv_L_avg = squeeze(mean(plv_alls_L_c3c4,3));

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLV\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    plv_alls_S_c3c4(:,:,i) = squeeze(plv(:,:,44,15));
end
plv_S_avg = squeeze(mean(plv_alls_S_c3c4,3));

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
plv_L_avg = plv_L_avg - repmat(mean(plv_L_avg(:,idx),2),[1 length(time_axis)]);
plv_S_avg = plv_S_avg - repmat(mean(plv_S_avg(:,idx),2),[1 length(time_axis)]);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, plv_L_avg);colorbar;axis xy;caxis([0 0.3])
subplot(1,2,2);imagesc(-1000:4:1996,1:30, plv_S_avg);colorbar; axis xy;caxis([0 0.3])

%% PLI
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLI\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    pli_alls_L_c3c4(:,:,i) = squeeze(pli(:,:,44,15));
end
pli_L_avg = squeeze(mean(pli_alls_L_c3c4,3));

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLI\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    pli_alls_S_c3c4(:,:,i) = squeeze(pli(:,:,44,15));
end
pli_S_avg = squeeze(mean(pli_alls_S_c3c4,3));

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
pli_L_avg = pli_L_avg - repmat(mean(pli_L_avg(:,idx),2),[1 length(time_axis)]);
pli_S_avg = pli_S_avg - repmat(mean(pli_S_avg(:,idx),2),[1 length(time_axis)]);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, pli_L_avg);colorbar;axis xy;caxis([0 0.3])
subplot(1,2,2);imagesc(-1000:4:1996,1:30, pli_S_avg);colorbar; axis xy;caxis([0 0.3])

%% WPLI
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    wpli_alls_L_c3c4(:,:,i) = squeeze(wpli(:,:,44,15));
end
wpli_L_avg = squeeze(mean(wpli_alls_L_c3c4,3));

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    wpli_alls_S_c3c4(:,:,i) = squeeze(wpli(:,:,44,15));
end
wpli_S_avg = squeeze(mean(wpli_alls_S_c3c4,3));

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
wpli_L_avg = wpli_L_avg - repmat(mean(wpli_L_avg(:,idx),2),[1 length(time_axis)]);
wpli_S_avg = wpli_S_avg - repmat(mean(wpli_S_avg(:,idx),2),[1 length(time_axis)]);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, wpli_L_avg);colorbar;axis xy;caxis([0 0.4])
subplot(1,2,2);imagesc(-1000:4:1996,1:30, wpli_S_avg);colorbar; axis xy;caxis([0 0.4])




