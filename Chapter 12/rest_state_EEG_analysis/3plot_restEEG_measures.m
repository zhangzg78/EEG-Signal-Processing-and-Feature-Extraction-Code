clc;clear all;close all
band = [8 13]; 
load('D:\FC\demo\restEEG_analysis\measures_test_plot\COH\EC_coh.mat')
load('D:\FC\demo\restEEG_analysis\measures_test_plot\COH\EO_coh.mat')
load('D:\FC\demo\restEEG_analysis\measures_test_plot\COH\Freq.mat')
idx = dsearchn(Freq', band');
EC_coh = squeeze(mean(EC_coh(idx(1,1):idx(2,1),:,:,:),1));
EO_coh = squeeze(mean(EO_coh(idx(1,1):idx(2,1),:,:,:),1));
EC_coh_avg = mean(EC_coh,3);
EO_coh_avg = mean(EO_coh,3);
figure;
subplot(1,2,1);imagesc(EC_coh_avg);caxis([0 0.3]);colorbar;axis xy
subplot(1,2,2);imagesc(EO_coh_avg);caxis([0 0.3]);colorbar;axis xy
%%
clc;clear all;close all
load('D:\FC\demo\restEEG_analysis\measures_test_plot\PLV\EC_plv.mat')
load('D:\FC\demo\restEEG_analysis\measures_test_plot\PLV\EO_plv.mat')
EC_plv_avg = mean(EC_plv,3);
EO_plv_avg = mean(EO_plv,3);
figure;
subplot(1,2,1);imagesc(EC_plv_avg);caxis([0.3 0.5]);colorbar;axis xy
subplot(1,2,2);imagesc(EO_plv_avg);caxis([0.3 0.5]);colorbar;axis xy
%%
clc;clear all;close all
load('D:\FC\demo\restEEG_analysis\measures_test_plot\PLI\EC_pli.mat')
load('D:\FC\demo\restEEG_analysis\measures_test_plot\PLI\EO_pli.mat')
EC_pli_avg = mean(EC_pli,3);
EO_pli_avg = mean(EO_pli,3);
figure;
subplot(1,2,1);imagesc(EC_pli_avg);caxis([0.2 0.4]);colorbar;axis xy
subplot(1,2,2);imagesc(EO_pli_avg);caxis([0.2 0.4]);colorbar;axis xy   
%%
clc;clear all;close all
load('D:\FC\demo\restEEG_analysis\measures_test_plot\WPLI\EC_wpli.mat')
load('D:\FC\demo\restEEG_analysis\measures_test_plot\WPLI\EO_wpli.mat')
EC_wpli_avg = mean(EC_wpli,3);
EO_wpli_avg = mean(EO_wpli,3);
figure;
subplot(1,2,1);imagesc(EC_wpli_avg);caxis([0.3 0.6]);colorbar;axis xy
subplot(1,2,2);imagesc(EO_wpli_avg);caxis([0.3 0.6]);colorbar;axis xy  
















