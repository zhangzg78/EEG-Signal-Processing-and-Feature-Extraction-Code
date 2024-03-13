clear all; close all; clc
%%
ECDir = 'D:\FC\demo\restEEG_analysis\csd\EC';
EODir = 'D:\FC\demo\restEEG_analysis\csd\EO';

DirEC = dir(fullfile(ECDir,'*.set'));  %%%% find all the *.set file in 'ECDir'
DirEO = dir(fullfile(EODir,'*.set'));

FileNamesEC = {DirEC.name};
FileNamesEO = {DirEO.name};
%% compute 1st measure (coherence)
for f = 1:numel(FileNamesEC)  
    EEG = pop_loadset('filename',FileNamesEC{1,f},'filepath',ECDir);
    EEG = eeg_checkset( EEG );
    N = EEG.pnts;
    SampleRate = EEG.srate;
    NFFT = 2^nextpow2(N);
    Freq = SampleRate/2*linspace(0,1,NFFT/2+1); 
    for chan = 1:size(EEG.data,1)
        for epochs = 1:size(EEG.data,3)
            ffts(:,chan,epochs) = fft(squeeze(EEG.data(chan,:,epochs)),NFFT)/N;
        end
    end
    for channel1 = 1:size(EEG.data,1)
            for channel2 = 1:size(EEG.data,1)
                fx = squeeze(ffts(:,channel1,:));
                Pxx = fx.*conj(fx)/N;
                MeanPx = mean(Pxx,2); 
                fy = squeeze(ffts(:,channel2,:));
                Pyy = fy.*conj(fy)/N; 
                MeanPy = mean(Pyy,2); 
                Pxy = fx.*conj(fy)/N;
                MeanPxy = mean(Pxy,2); 
                C = (abs(MeanPxy).^2)./(MeanPx.*MeanPy); 
                EC_coh(:,channel1,channel2,f) = C; 
            end
    end
    clear ffts
end
EC_coh = EC_coh(1:NFFT/2 + 1,:,:,:);  
save EC_coh.mat EC_coh
save Freq.mat Freq                
                
for f = 1:numel(FileNamesEO)  
    EEG = pop_loadset('filename',FileNamesEO{1,f},'filepath',EODir);
    EEG = eeg_checkset( EEG );
    N = EEG.pnts;
    SampleRate = EEG.srate;
    NFFT = 2^nextpow2(N);
    Freq = SampleRate/2*linspace(0,1,NFFT/2+1); 
    for chan = 1:size(EEG.data,1)
        for epochs = 1:size(EEG.data,3)
            ffts(:,chan,epochs) = fft(squeeze(EEG.data(chan,:,epochs)),NFFT)/N;
        end
    end
    for channel1 = 1:size(EEG.data,1)
            for channel2 = 1:size(EEG.data,1)
                fx = squeeze(ffts(:,channel1,:));
                Pxx = fx.*conj(fx)/N;
                MeanPx = mean(Pxx,2); 
                fy = squeeze(ffts(:,channel2,:));
                Pyy = fy.*conj(fy)/N; 
                MeanPy = mean(Pyy,2); 
                Pxy = fx.*conj(fy)/N;
                MeanPxy = mean(Pxy,2); 
                C = (abs(MeanPxy).^2)./(MeanPx.*MeanPy); 
                EO_coh(:,channel1,channel2,f) = C; 
            end
    end
    clear ffts
end
EO_coh = EO_coh(1:NFFT/2 + 1,:,:,:);  
save EO_coh.mat EO_coh      

%% 2nd and 3rd measures (phase-locking value and phase lag index)
band = [8 13]; %%%% study the plv/pli of alpha band     
for f = 1:numel(FileNamesEC)
    EEG = pop_loadset('filename',FileNamesEC{1,f},'filepath',ECDir);
    EEG = eeg_checkset( EEG );
    eeg_filtered = eegfilt(reshape(EEG.data, [size(EEG.data,1) size(EEG.data,2)*size(EEG.data,3)]),...
    EEG.srate,band(1,1),band(1,2),0,3*fix(EEG.srate/band(1,1)),0,'fir1',0); 
    %%%%   
    for channels = 1:size(EEG.data,1)
        band_phase(channels,:) = angle(hilbert(eeg_filtered(channels,:))); 
    end
    
    perc10w =  floor(size(band_phase,2)*0.1);
    band_phase = band_phase(:,perc10w+1:end-perc10w);
    epoch_num = floor(size(band_phase,2)/size(EEG.data,2));
    band_phase = band_phase(:,1:epoch_num*size(EEG.data,2));
    band_phase = reshape(band_phase,[size(EEG.data,1) size(EEG.data,2) epoch_num]);
    
    for channel1 = 1:size(band_phase,1)
         for channel2 = 1:size(band_phase,1)
             for epochs = 1:size(band_phase,3)
                 channel1_phase = squeeze(band_phase(channel1,:,epochs));
                 channel2_phase = squeeze(band_phase(channel2,:,epochs));
                 rp = channel1_phase - channel2_phase; 
                 %%% PLV
                 sub_plv(channel1,channel2,epochs) = abs(sum(exp(1i*rp))/length(rp));
                 %%% PLI
                 sub_pli(channel1,channel2,epochs) = abs(mean(sign((abs(rp)- pi).*rp)));
             end
         end
    end           
   
   EC_pli(:,:,f) = mean(sub_pli,3); 
   EC_plv(:,:,f) = mean(sub_plv,3);
   clear band_phase sub_pli sub_plv rp
end
save EC_plv.mat EC_plv
save EC_pli.mat EC_pli           


for f = 1:numel(FileNamesEO)
    EEG = pop_loadset('filename',FileNamesEO{1,f},'filepath',EODir);
    EEG = eeg_checkset( EEG );
    eeg_filtered = eegfilt(reshape(EEG.data, [size(EEG.data,1) size(EEG.data,2)*size(EEG.data,3)]),...
    EEG.srate,band(1,1),band(1,2),0,3*fix(EEG.srate/band(1,1)),0,'fir1',0); 
    %%%%   
    for channels = 1:size(EEG.data,1)
        band_phase(channels,:) = angle(hilbert(eeg_filtered(channels,:))); 
    end 

    perc10w =  floor(size(band_phase,2)*0.1);
    band_phase = band_phase(:,perc10w+1:end-perc10w);
    epoch_num = floor(size(band_phase,2)/size(EEG.data,2));
    band_phase = band_phase(:,1:epoch_num*size(EEG.data,2));
    band_phase = reshape(band_phase,[size(EEG.data,1) size(EEG.data,2) epoch_num]);    
       
    for channel1 = 1:size(band_phase,1)
         for channel2 = 1:size(band_phase,1)
             for epochs = 1:size(band_phase,3)
                 channel1_phase = squeeze(band_phase(channel1,:,epochs));
                 channel2_phase = squeeze(band_phase(channel2,:,epochs));
                 rp = channel1_phase - channel2_phase; 
                 %%% PLV
                 sub_plv(channel1,channel2,epochs) = abs(sum(exp(1i*rp))/length(rp));
                 %%% PLI
                 sub_pli(channel1,channel2,epochs) = abs(mean(sign((abs(rp)- pi).*rp)));
             end
         end
    end
   EO_pli(:,:,f) = mean(sub_pli,3); 
   EO_plv(:,:,f) = mean(sub_plv,3);
   clear band_phase sub_pli sub_plv rp
end
save EO_plv.mat EO_plv
save EO_pli.mat EO_pli   
%% compute 4th measure (weighted phase lag index)
band = [8 13]; %%%% study the wpli of alpha band     
for f = 1:numel(FileNamesEC)
    EEG = pop_loadset('filename',FileNamesEC{1,f},'filepath',ECDir);
    EEG = eeg_checkset( EEG );
    eeg_filtered = eegfilt(reshape(EEG.data, [size(EEG.data,1) size(EEG.data,2)*size(EEG.data,3)]),...
    EEG.srate,band(1,1),band(1,2),0,3*fix(EEG.srate/band(1,1)),0,'fir1',0); 
    %%%%
    for channels = 1:size(EEG.data,1)
        band_hilbert(channels,:) = hilbert(eeg_filtered(channels,:)); 
    end 
    
    perc10w =  floor(size(band_hilbert,2)*0.1);
    band_hilbert = band_hilbert(:,perc10w+1:end-perc10w);
    epoch_num = floor(size(band_hilbert,2)/size(EEG.data,2));
    band_hilbert = band_hilbert(:,1:epoch_num*size(EEG.data,2));
    band_hilbert = reshape(band_hilbert,[size(EEG.data,1) size(EEG.data,2) epoch_num]); 
    
    for channel1 = 1:size(band_hilbert,1)
         for channel2 = 1:size(band_hilbert,1)
             for epochs = 1:size(band_hilbert,3)
                 channel1_hilbert = band_hilbert(channel1,:,epochs);
                 channel2_hilbert = band_hilbert(channel2,:,epochs);
                 crossspec = channel1_hilbert.* conj(channel2_hilbert); 
                 crossspec_imag = imag(crossspec); 
                 sub_wpli(channel1,channel2,epochs) = abs(mean(crossspec_imag))/mean(abs(crossspec_imag));                                 
             end
         end
    end
    EC_wpli(:,:,f) = mean(sub_wpli,3); 
    clear band_hilbert sub_wpli
end
EC_wpli(isnan(EC_wpli)) = 0;
save EC_wpli.mat EC_wpli    
    
for f = 1:numel(FileNamesEO)
    EEG = pop_loadset('filename',FileNamesEO{1,f},'filepath',EODir);
    EEG = eeg_checkset( EEG );
    eeg_filtered = eegfilt(reshape(EEG.data, [size(EEG.data,1) size(EEG.data,2)*size(EEG.data,3)]),...
    EEG.srate,band(1,1),band(1,2),0,3*fix(EEG.srate/band(1,1)),0,'fir1',0); 
    %%%%
    for channels = 1:size(EEG.data,1)
        band_hilbert(channels,:) = hilbert(eeg_filtered(channels,:)); 
    end 
    
    perc10w =  floor(size(band_hilbert,2)*0.1);
    band_hilbert = band_hilbert(:,perc10w+1:end-perc10w);
    epoch_num = floor(size(band_hilbert,2)/size(EEG.data,2));
    band_hilbert = band_hilbert(:,1:epoch_num*size(EEG.data,2));
    band_hilbert = reshape(band_hilbert,[size(EEG.data,1) size(EEG.data,2) epoch_num]); 
    
    for channel1 = 1:size(band_hilbert,1)
         for channel2 = 1:size(band_hilbert,1)
             for epochs = 1:size(band_hilbert,3)
                 channel1_hilbert = band_hilbert(channel1,:,epochs);
                 channel2_hilbert = band_hilbert(channel2,:,epochs);
                 crossspec = channel1_hilbert.* conj(channel2_hilbert); 
                 crossspec_imag = imag(crossspec); 
                 sub_wpli(channel1,channel2,epochs) = abs(mean(crossspec_imag))/mean(abs(crossspec_imag));                                 
             end
         end
    end
    EO_wpli(:,:,f) = mean(sub_wpli,3); 
    clear band_hilbert sub_wpli
end
EO_wpli(isnan(EO_wpli)) = 0;
save EO_wpli.mat EO_wpli
%% plot the coherence/plv/pli/wpli of alpha band
clc;clear all;close all
band = [8 13]; 
load('D:\FC\demo\restEEG_analysis\EC_coh.mat')
load('D:\FC\demo\restEEG_analysis\EO_coh.mat')
load('D:\FC\demo\restEEG_analysis\Freq.mat')
idx = dsearchn(Freq', band');
EC_coh = squeeze(mean(EC_coh(idx(1,1):idx(2,1),:,:,:),1));
EO_coh = squeeze(mean(EO_coh(idx(1,1):idx(2,1),:,:,:),1));
EC_coh_avg = mean(EC_coh,3);
EO_coh_avg = mean(EO_coh,3);
figure;
subplot(1,2,1);imagesc(EC_coh_avg);caxis([0 0.3]);axis xy
subplot(1,2,2);imagesc(EO_coh_avg);caxis([0 0.3]);axis xy


load('D:\FC\demo\restEEG_analysis\EC_plv.mat')
load('D:\FC\demo\restEEG_analysis\EO_plv.mat')
EC_plv_avg = mean(EC_plv,3);
EO_plv_avg = mean(EO_plv,3);
figure;
subplot(1,2,1);imagesc(EC_plv_avg);caxis([0.3 0.5]);axis xy
subplot(1,2,2);imagesc(EO_plv_avg);caxis([0.3 0.5]);axis xy
    
load('D:\FC\demo\restEEG_analysis\EC_pli.mat')
load('D:\FC\demo\restEEG_analysis\EO_pli.mat')
EC_pli_avg = mean(EC_pli,3);
EO_pli_avg = mean(EO_pli,3);
figure;
subplot(1,2,1);imagesc(EC_pli_avg);caxis([0.2 0.4]);axis xy
subplot(1,2,2);imagesc(EO_pli_avg);caxis([0.2 0.4]);axis xy   

load('D:\FC\demo\restEEG_analysis\EC_wpli.mat')
load('D:\FC\demo\restEEG_analysis\EO_wpli.mat')
EC_wpli_avg = mean(EC_wpli,3);
EO_wpli_avg = mean(EO_wpli,3);
figure;
subplot(1,2,1);imagesc(EC_wpli_avg);caxis([0.3 0.6]);axis xy
subplot(1,2,2);imagesc(EO_wpli_avg);caxis([0.3 0.6]);axis xy  