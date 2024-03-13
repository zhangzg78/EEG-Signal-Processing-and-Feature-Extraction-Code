%% PLV
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLV\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    plv_alls_L_c3c4(:,:,i) = squeeze(plv(:,:,44,15));
end

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLV\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    plv_alls_S_c3c4(:,:,i) = squeeze(plv(:,:,44,15));
end

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
plv_alls_L_c3c4 = plv_alls_L_c3c4 - repmat(mean(plv_alls_L_c3c4(:,idx,:),2),[1 length(time_axis) 1]);
plv_alls_S_c3c4 = plv_alls_S_c3c4 - repmat(mean(plv_alls_S_c3c4(:,idx,:),2),[1 length(time_axis) 1]);

for i = 1:size(plv_alls_L_c3c4,1)
    for j = 1:size(plv_alls_L_c3c4,2)
        [~, p_L_larger(i,j)] = ttest(squeeze(plv_alls_L_c3c4(i,j,:)), squeeze(plv_alls_S_c3c4(i,j,:)), 0.05, 'right');
        [~, p_L_smaller(i,j)] = ttest(squeeze(plv_alls_L_c3c4(i,j,:)), squeeze(plv_alls_S_c3c4(i,j,:)), 0.05, 'left');
    end
end

[p_fdr, p_L_larger_masked] = fdr(p_L_larger, 0.05);
[p_fdr, p_L_smaller_masked] = fdr(p_L_smaller, 0.05);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, p_L_larger_masked);colorbar;axis xy;
subplot(1,2,2);imagesc(-1000:4:1996,1:30, p_L_smaller_masked);colorbar; axis xy;


%% PLI
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLI\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    pli_alls_L_c3c4(:,:,i) = squeeze(pli(:,:,44,15));
end

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\PLI\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    pli_alls_S_c3c4(:,:,i) = squeeze(pli(:,:,44,15));
end

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
pli_alls_L_c3c4 = pli_alls_L_c3c4 - repmat(mean(pli_alls_L_c3c4(:,idx,:),2),[1 length(time_axis) 1]);
pli_alls_S_c3c4 = pli_alls_S_c3c4 - repmat(mean(pli_alls_S_c3c4(:,idx,:),2),[1 length(time_axis) 1]);

for i = 1:size(pli_alls_L_c3c4,1)
    for j = 1:size(pli_alls_L_c3c4,2)
        [~, p_L_larger(i,j)] = ttest(squeeze(pli_alls_L_c3c4(i,j,:)), squeeze(pli_alls_S_c3c4(i,j,:)), 0.05, 'right');
        [~, p_L_smaller(i,j)] = ttest(squeeze(pli_alls_L_c3c4(i,j,:)), squeeze(pli_alls_S_c3c4(i,j,:)), 0.05, 'left');
    end
end

[p_fdr, p_L_larger_masked] = fdr(p_L_larger, 0.05);
[p_fdr, p_L_smaller_masked] = fdr(p_L_smaller, 0.05);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, p_L_larger_masked);colorbar;axis xy;
subplot(1,2,2);imagesc(-1000:4:1996,1:30, p_L_smaller_masked);colorbar; axis xy;

%% WPLI
clc;clear all;close all

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\L\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    wpli_alls_L_c3c4(:,:,i) = squeeze(wpli(:,:,44,15));
end

DataDir = 'D:\FC\demo\eventEEG_analysis\ps_csd\WPLI\S\';
DirData = dir(fullfile(DataDir,'*.mat'));  
filename = {DirData.name};
for i = 1:length(filename)
    load(strcat(DataDir,filename{1,i}));    
    wpli_alls_S_c3c4(:,:,i) = squeeze(wpli(:,:,44,15));
end

time_axis = -1000:4:1996;
baseline = [-800 -200];
idx =  find(time_axis > baseline(1,1) & time_axis < baseline(1,2));
wpli_alls_L_c3c4 = wpli_alls_L_c3c4 - repmat(mean(wpli_alls_L_c3c4(:,idx,:),2),[1 length(time_axis) 1]);
wpli_alls_S_c3c4 = wpli_alls_S_c3c4 - repmat(mean(wpli_alls_S_c3c4(:,idx,:),2),[1 length(time_axis) 1]);

for i = 1:size(wpli_alls_L_c3c4,1)
    for j = 1:size(wpli_alls_L_c3c4,2)
        [~, p_L_larger(i,j)] = ttest(squeeze(wpli_alls_L_c3c4(i,j,:)), squeeze(wpli_alls_S_c3c4(i,j,:)), 0.05, 'right');
        [~, p_L_smaller(i,j)] = ttest(squeeze(wpli_alls_L_c3c4(i,j,:)), squeeze(wpli_alls_S_c3c4(i,j,:)), 0.05, 'left');
    end
end

[p_fdr, p_L_larger_masked] = fdr(p_L_larger, 0.05);
[p_fdr, p_L_smaller_masked] = fdr(p_L_smaller, 0.05);
figure;
subplot(1,2,1);imagesc(-1000:4:1996,1:30, p_L_larger_masked);colorbar;axis xy;
subplot(1,2,2);imagesc(-1000:4:1996,1:30, p_L_smaller_masked);colorbar; axis xy;